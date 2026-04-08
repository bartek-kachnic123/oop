<?php

namespace App\Controller;

use App\Entity\Product;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Serializer\SerializerInterface;

#[Route('/api/product')]
class ProductController extends AbstractController
{
    private EntityManagerInterface $em;
    private SerializerInterface $serializer;

    public function __construct(EntityManagerInterface $em, SerializerInterface $serializer)
    {
        $this->em = $em;
	$this->serializer = $serializer;
    }

    #[Route('', methods:['GET'])]
    public function index(): JsonResponse
    {
        $products = $this->em->getRepository(Product::class)->findAll();
        $data = $this->serializer->serialize($products, 'json');
        return new JsonResponse($data, 200, [], true);
    }

    #[Route('/{id}', methods:['GET'])]
    public function show(int $id): JsonResponse
    {
	$product = $this->em->getRepository(Product::class)->find($id);
	if (!$product) return new JsonResponse(['error' => 'Not found'], 404);
	return new JsonResponse($this->serializer->serialize($product, 'json'), 200, [], true);
    }

    #[Route('', methods:['POST'])]
    public function create(Request $request): JsonResponse
    {
        $data = json_decode($request->getContent(), true);
        $product = new Product();
        $product->setName($data['name'] ?? '');
        $product->setPrice($data['price'] ?? 0);
        $product->setDescription($data['description'] ?? '');
        $this->em->persist($product);
        $this->em->flush();
        return new JsonResponse($this->serializer->serialize($product, 'json'), 201, [], true);
    }

    #[Route('/{id}', methods:['PUT'])]
    public function update(int $id, Request $request): JsonResponse
    {
        $product = $this->em->getRepository(Product::class)->find($id);
        if (!$product) return new JsonResponse(['error'=>'Not found'], 404);
        $data = json_decode($request->getContent(), true);
        $product->setName($data['name'] ?? $product->getName());
        $product->setPrice($data['price'] ?? $product->getPrice());
        $product->setDescription($data['description'] ?? $product->getDescription());
        $this->em->flush();
        return new JsonResponse($this->serializer->serialize($product, 'json'), 200, [], true);
    }

    #[Route('/{id}', methods:['DELETE'])]
    public function delete(int $id): JsonResponse
    {
        $product = $this->em->getRepository(Product::class)->find($id);
        if (!$product) return new JsonResponse(['error'=>'Not found'], 404);
        $this->em->remove($product);
        $this->em->flush();
        return new JsonResponse(null, 204);
    }
}

