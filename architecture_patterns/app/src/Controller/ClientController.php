<?php

namespace App\Controller;

use App\Entity\Client;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

#[Route('/api/client')]
class ClientController extends AbstractController
{
    #[Route('', methods:['POST'])]
    public function create(Request $request, EntityManagerInterface $em): JsonResponse
    {
        $data = json_decode($request->getContent(), true);
        $client = new Client();
        $client->setName($data['name'] ?? '');
        $client->setEmail($data['email'] ?? '');
        $em->persist($client);
        $em->flush();
        return new JsonResponse($this->clientToArray($client), 201);
    }

    #[Route('', methods:['GET'])]
    public function list(EntityManagerInterface $em): JsonResponse
    {
        $clients = $em->getRepository(Client::class)->findAll();
        $data = array_map(fn($c) => $this->clientToArray($c), $clients);
        return new JsonResponse($data, 200);
    }

    #[Route('/{id}', methods:['GET'])]
    public function show(int $id, EntityManagerInterface $em): JsonResponse
    {
        $client = $em->getRepository(Client::class)->find($id);
        if (!$client) return new JsonResponse(['error'=>'Not found'], 404);
        return new JsonResponse($this->clientToArray($client), 200);
    }

    #[Route('/{id}', methods:['PUT'])]
    public function update(int $id, Request $request, EntityManagerInterface $em): JsonResponse
    {
        $client = $em->getRepository(Client::class)->find($id);
        if (!$client) return new JsonResponse(['error'=>'Not found'], 404);
        $data = json_decode($request->getContent(), true);
        $client->setName($data['name'] ?? $client->getName());
        $client->setEmail($data['email'] ?? $client->getEmail());
        $em->flush();
        return new JsonResponse($this->clientToArray($client), 200);
    }

    #[Route('/{id}', methods:['DELETE'])]
    public function delete(int $id, EntityManagerInterface $em): JsonResponse
    {
        $client = $em->getRepository(Client::class)->find($id);
        if (!$client) return new JsonResponse(['error'=>'Not found'], 404);
        $em->remove($client);
        $em->flush();
        return new JsonResponse(['success'=>true], 200);
    }

    private function clientToArray(Client $client): array
    {
        return [
            'id' => $client->getId(),
            'name' => $client->getName(),
            'email' => $client->getEmail(),
        ];
    }
}

