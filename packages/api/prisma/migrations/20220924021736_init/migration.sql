-- CreateTable
CREATE TABLE "client" (
    "id" UUID NOT NULL,
    "name" VARCHAR(35) NOT NULL,
    "dob" DATE,
    "email" VARCHAR(50) NOT NULL,
    "password" VARCHAR(35) NOT NULL,
    "password_hash" BYTEA NOT NULL,
    "contact" VARCHAR(13),
    "Type" VARCHAR(10) NOT NULL,

    CONSTRAINT "client_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "address" (
    "id" UUID NOT NULL,
    "uid" UUID NOT NULL,
    "city" VARCHAR(35) NOT NULL,
    "state" VARCHAR(35) NOT NULL,
    "country" VARCHAR(35) NOT NULL,
    "pin" INTEGER NOT NULL,

    CONSTRAINT "address_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "item" (
    "id" UUID NOT NULL,
    "sid" UUID NOT NULL,
    "name" VARCHAR(35) NOT NULL,
    "price" DOUBLE PRECISION NOT NULL,
    "tax" DOUBLE PRECISION NOT NULL,
    "quantity" INTEGER NOT NULL,

    CONSTRAINT "item_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "image" (
    "id" UUID NOT NULL,
    "itid" UUID NOT NULL,
    "data" BYTEA NOT NULL,
    "count" INTEGER NOT NULL,

    CONSTRAINT "image_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tags" (
    "id" UUID NOT NULL,
    "itid" UUID NOT NULL,
    "category" VARCHAR(15) NOT NULL,

    CONSTRAINT "tags_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "billing" (
    "id" UUID NOT NULL,
    "uid" UUID NOT NULL,
    "total" DOUBLE PRECISION NOT NULL,
    "tax" DOUBLE PRECISION NOT NULL,
    "total_with_tax" DOUBLE PRECISION NOT NULL,
    "payment_type" VARCHAR(20) NOT NULL,
    "time" TIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "billing_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "item_billing" (
    "id" UUID NOT NULL,
    "itid" UUID NOT NULL,
    "bid" UUID NOT NULL,
    "quantity" INTEGER NOT NULL,
    "price" DOUBLE PRECISION NOT NULL,
    "tax" DOUBLE PRECISION NOT NULL,

    CONSTRAINT "item_billing_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "wish_list" (
    "id" UUID NOT NULL,
    "uid" UUID NOT NULL,
    "itid" UUID NOT NULL,

    CONSTRAINT "wish_list_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cart" (
    "id" UUID NOT NULL,
    "uid" UUID NOT NULL,
    "itid" UUID NOT NULL,
    "quantity" INTEGER NOT NULL,

    CONSTRAINT "cart_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ratting" (
    "id" UUID NOT NULL,
    "uid" UUID NOT NULL,
    "itid" UUID NOT NULL,
    "ratting" INTEGER NOT NULL,
    "comments" VARCHAR(255),

    CONSTRAINT "ratting_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "client_email_key" ON "client"("email");

-- CreateIndex
CREATE UNIQUE INDEX "address_uid_key" ON "address"("uid");

-- CreateIndex
CREATE UNIQUE INDEX "item_name_key" ON "item"("name");

-- AddForeignKey
ALTER TABLE "address" ADD CONSTRAINT "addressOf" FOREIGN KEY ("uid") REFERENCES "client"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "item" ADD CONSTRAINT "soledBy" FOREIGN KEY ("sid") REFERENCES "client"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "image" ADD CONSTRAINT "imageOf" FOREIGN KEY ("itid") REFERENCES "item"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tags" ADD CONSTRAINT "tagsOf" FOREIGN KEY ("itid") REFERENCES "item"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "billing" ADD CONSTRAINT "billOf" FOREIGN KEY ("uid") REFERENCES "client"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "item_billing" ADD CONSTRAINT "billOfitem" FOREIGN KEY ("itid") REFERENCES "item"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "item_billing" ADD CONSTRAINT "billingOfitem" FOREIGN KEY ("bid") REFERENCES "billing"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wish_list" ADD CONSTRAINT "wishListOf" FOREIGN KEY ("uid") REFERENCES "client"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wish_list" ADD CONSTRAINT "wishListOfItem" FOREIGN KEY ("itid") REFERENCES "item"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cart" ADD CONSTRAINT "cartOf" FOREIGN KEY ("uid") REFERENCES "client"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cart" ADD CONSTRAINT "cartOfItem" FOREIGN KEY ("itid") REFERENCES "item"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ratting" ADD CONSTRAINT "rattingOf" FOREIGN KEY ("uid") REFERENCES "client"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ratting" ADD CONSTRAINT "rattingOfItem" FOREIGN KEY ("itid") REFERENCES "item"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
