# Bingo-Driven – Back-End

API Node.js + Prisma + Postgres pronta pra rodar em contêiner.  
(Só dar o _docker up_)

---

## 1) Com Docker Compose

docker compose -f docker-compose.backend.yml up -d
API → http://localhost:5000
Banco → porta 5432 (user/password: postgres)

Desligar:

docker compose -f docker-compose.backend.yml down


## 2) Docker puro

# 1 = rede + volume
docker network create my_network
docker volume  create myvolume

# 2 = Postgres
docker run -d --name db --network my_network \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 \
  -v myvolume:/var/lib/postgresql/data \
  postgres:17-alpine

# 3 = API (build + run)
cd Bingo-Driven-BackEnd
docker build -t backend .

docker run -d --name api --network my_network \
  --env-file .env \
  -p 5000:5000 \
  backend

Deploy link: https://bingo-driven-backend-kyxa.onrender.com
