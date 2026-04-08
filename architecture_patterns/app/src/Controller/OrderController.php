<?php

namespace App\Controller;

use App\Entity\Order;
use App\Entity\Product;
use App\Entity\Client;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

#[Route('/api/order')]
class OrderController extends AbstractController
{
    private EntityManagerInterface $em;

    public function __construct(EntityManagerInterface $em)
    {
        $this->em = $em;
    }

    #[Route('', methods:['POST'])]
    public function create(Request $request): JsonResponse
    {
        $data = json_decode($request->getContent(), true);
        $client = $this->em->getRepository(Client::class)->find($data['client_id'] ?? 0);
        if (!$client) return new JsonResponse(['error'=>'Client not found'], 404);
        $order = new Order();
        $order->setClient($client);
        if (!empty($data['products'])) {
            foreach ($data['products'] as $productId) {
                $product = $this->em->getRepository(Product::class)->find($productId);
                if ($product) $order->addProduct($product);
            }
        }
        $this->em->persist($order);
        $this->em->flush();
        $response = $this->orderToArray($order);
        return new JsonResponse($response, 201);
    }

    #[Route('', methods:['GET'])]
    public function list(): JsonResponse
    {
        $orders = $this->em->getRepository(Order::class)->findAll();
        $data = array_map(fn($order) => $this->orderToArray($order), $orders);
        return new JsonResponse($data, 200);
    }

    #[Route('/{id}', methods:['GET'])]
    public function show(int $id): JsonResponse
    {
        $order = $this->em->getRepository(Order::class)->find($id);
        if (!$order) return new JsonResponse(['error'=>'Not found'], 404);
        return new JsonResponse($this->orderToArray($order), 200);
    }

    #[Route('/{id}', methods:['PUT'])]
    public function update(int $id, Request $request): JsonResponse
    {
        $order = $this->em->getRepository(Order::class)->find($id);
        if (!$order) return new JsonResponse(['error'=>'Not found'], 404);
        $data = json_decode($request->getContent(), true);
        if (!empty($data['client_id'])) {
            $client = $this->em->getRepository(Client::class)->find($data['client_id']);
            if ($client) $order->setClient($client);
        }
        if (!empty($data['products'])) {
            $order->getProduct()->clear();
            foreach ($data['products'] as $productId) {
                $product = $this->em->getRepository(Product::class)->find($productId);
                if ($product) $order->addProduct($product);
            }
        }
        $this->em->flush();
        return new JsonResponse($this->orderToArray($order), 200);
    }

    #[Route('/{id}', methods:['DELETE'])]
    public function delete(int $id): JsonResponse
    {
        $order = $this->em->getRepository(Order::class)->find($id);
        if (!$order) return new JsonResponse(['error'=>'Not found'], 404);
        $this->em->remove($order);
        $this->em->flush();
        return new JsonResponse(['success'=>true], 200);
    }

    private function orderToArray(Order $order): array
    {
        return [
            'id' => $order->getId(),
            'client' => [
                'id' => $order->getClient()?->getId(),
                'name' => $order->getClient()?->getName(),
                'email' => $order->getClient()?->getEmail(),
            ],
            'products' => $order->getProduct()->map(fn($p) => [
                'id' => $p->getId(),
                'name' => $p->getName(),
                'price' => $p->getPrice(),
                'description' => $p->getDescription(),
            ])->toArray()
        ];
    }
}

