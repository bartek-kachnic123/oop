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
    private EntityManagerInterface $em;

    public function __construct(EntityManagerInterface $em)
    {
        $this->em = $em;
    }

    #[Route('', methods:['POST'])]
    public function create(Request $request): JsonResponse
    {
        $data = json_decode($request->getContent(), true);
        $client = new Client();
        $client->setName($data['name'] ?? '');
        $client->setEmail($data['email'] ?? '');
        $this->em->persist($client);
        $this->em->flush();
        return new JsonResponse($this->clientToArray($client), 201);
    }

    #[Route('', methods:['GET'])]
    public function list(): JsonResponse
    {
        $clients = $this->em->getRepository(Client::class)->findAll();
        $data = array_map(fn($c) => $this->clientToArray($c), $clients);
        return new JsonResponse($data, 200);
    }

    #[Route('/{id}', methods:['GET'])]
    public function show(int $id): JsonResponse
    {
        $client = $this->em->getRepository(Client::class)->find($id);
        if (!$client) return new JsonResponse(['error'=>'Not found'], 404);
        return new JsonResponse($this->clientToArray($client), 200);
    }

    #[Route('/{id}', methods:['PUT'])]
    public function update(int $id, Request $request): JsonResponse
    {
        $client = $this->em->getRepository(Client::class)->find($id);
        if (!$client) return new JsonResponse(['error'=>'Not found'], 404);
        $data = json_decode($request->getContent(), true);
        $client->setName($data['name'] ?? $client->getName());
        $client->setEmail($data['email'] ?? $client->getEmail());
        $this->em->flush();
        return new JsonResponse($this->clientToArray($client), 200);
    }

    #[Route('/{id}', methods:['DELETE'])]
    public function delete(int $id): JsonResponse
    {
        $client = $this->em->getRepository(Client::class)->find($id);
        if (!$client) return new JsonResponse(['error'=>'Not found'], 404);
        $this->em->remove($client);
        $this->em->flush();
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

