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
    #[Route('', methods:['POST'])]
    public function create(Request $request, EntityManagerInterface $em): JsonResponse
    {
        $data = json_decode($request->getContent(), true);
        $client = $em->getRepository(Client::class)->find($data['client_id'] ?? 0);
        if (!$client) return new JsonResponse(['error'=>'Client not found'], 404);
        $order = new Order();
        $order->setClient($client);
        if (!empty($data['products'])) {
            foreach ($data['products'] as $productId) {
                $product = $em->getRepository(Product::class)->find($productId);
                if ($product) $order->addProduct($product);
            }
        }
        $em->persist($order);
        $em->flush();
        $response = $this->orderToArray($order);
        return new JsonResponse($response, 201);
    }

    #[Route('', methods:['GET'])]
    public function list(EntityManagerInterface $em): JsonResponse
    {
        $orders = $em->getRepository(Order::class)->findAll();
        $data = array_map(fn($order) => $this->orderToArray($order), $orders);
        return new JsonResponse($data, 200);
    }

    #[Route('/{id}', methods:['GET'])]
    public function show(int $id, EntityManagerInterface $em): JsonResponse
    {
        $order = $em->getRepository(Order::class)->find($id);
        if (!$order) return new JsonResponse(['error'=>'Not found'], 404);
        return new JsonResponse($this->orderToArray($order), 200);
    }

    #[Route('/{id}', methods:['PUT'])]
    public function update(int $id, Request $request, EntityManagerInterface $em): JsonResponse
    {
        $order = $em->getRepository(Order::class)->find($id);
        if (!$order) return new JsonResponse(['error'=>'Not found'], 404);
        $data = json_decode($request->getContent(), true);
        if (!empty($data['client_id'])) {
            $client = $em->getRepository(Client::class)->find($data['client_id']);
            if ($client) $order->setClient($client);
        }
        if (!empty($data['products'])) {
            $order->getProduct()->clear();
            foreach ($data['products'] as $productId) {
                $product = $em->getRepository(Product::class)->find($productId);
                if ($product) $order->addProduct($product);
            }
        }
        $em->flush();
        return new JsonResponse($this->orderToArray($order), 200);
    }

    #[Route('/{id}', methods:['DELETE'])]
    public function delete(int $id, EntityManagerInterface $em): JsonResponse
    {
        $order = $em->getRepository(Order::class)->find($id);
        if (!$order) return new JsonResponse(['error'=>'Not found'], 404);
        $em->remove($order);
        $em->flush();
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

