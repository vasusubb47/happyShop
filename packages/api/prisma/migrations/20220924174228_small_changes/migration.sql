/*
  Warnings:

  - You are about to drop the column `Type` on the `client` table. All the data in the column will be lost.
  - Added the required column `sex` to the `client` table without a default value. This is not possible if the table is not empty.
  - Added the required column `type` to the `client` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "client" DROP COLUMN "Type",
ADD COLUMN     "sex" VARCHAR(10) NOT NULL,
ADD COLUMN     "type" VARCHAR(10) NOT NULL;
