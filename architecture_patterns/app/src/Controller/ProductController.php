<?php

namespace App\Controller;

use App\Entity\Product;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Serializer\SerializerInterface;

#[Route('/api/products')]
class ProductController extends AbstractController
{
    #[Route('', methods:['GET'])]
    public function index(EntityManagerInterface $em, SerializerInterface $serializer): JsonResponse
    {
        $products = $em->getRepository(Product::class)->findAll();
        $data = $serializer->serialize($products, 'json');
        return new JsonResponse($data, 200, [], true);
    }

    #[Route('', methods:['POST'])]
    public function create(Request $request, EntityManagerInterface $em, SerializerInterface $serializer): JsonResponse
    {
        $data = json_decode($request->getContent(), true);
        $product = new Product();
        $product->setName($data['name'] ?? '');
        $product->setPrice($data['price'] ?? 0);
        $product->setDescription($data['description'] ?? '');
        $em->persist($product);
        $em->flush();
        return new JsonResponse($serializer->serialize($product, 'json'), 201, [], true);
    }

    #[Route('/{id}', methods:['PUT'])]
    public function update(int $id, Request $request, EntityManagerInterface $em, SerializerInterface $serializer): JsonResponse
    {
        $product = $em->getRepository(Product::class)->find($id);
        if (!$product) return new JsonResponse(['error'=>'Not found'], 404);
        $data = json_decode($request->getContent(), true);
        $product->setName($data['name'] ?? $product->getName());
        $product->setPrice($data['price'] ?? $product->getPrice());
        $product->setDescription($data['description'] ?? $product->getDescription());
        $em->flush();
        return new JsonResponse($serializer->serialize($product, 'json'), 200, [], true);
    }

    #[Route('/{id}', methods:['DELETE'])]
    public function delete(int $id, EntityManagerInterface $em): JsonResponse
    {
        $product = $em->getRepository(Product::class)->find($id);
        if (!$product) return new JsonResponse(['error'=>'Not found'], 404);
        $em->remove($product);
        $em->flush();
        return new JsonResponse(null, 204);
    }
}
