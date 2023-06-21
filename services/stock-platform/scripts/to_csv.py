import boto3
from boto3.dynamodb.conditions import Key
import csv

dynamodb = boto3.resource("dynamodb", region_name="eu-north-1")
table = dynamodb.Table("stock-subscriptions")

response = table.query(KeyConditionExpression=Key("id").eq("A-1-2023"))

with open("merkinnät.csv", "a") as file:
    writer = csv.writer(file)
    header = [
        "nimi",
        "a-osakkeet",
        "osoite",
        "postinumero",
        "postitoimipaikka",
        "puhelinnumero",
        "sähköposti",
        "syntymäaika",
        "summa",
    ]
    writer.writerow(header)

    for row in response["Items"]:
        subscriber = row["subscriber"]

        name = " ".join(
            filter(
                None,
                [
                    subscriber["firstName"].strip(),
                    subscriber["middleNames"].strip(),
                    subscriber["lastName"].strip(),
                ],
            )
        )

        address = subscriber["address"]["street"]
        postal_code = subscriber["address"]["postalCode"]
        city = subscriber["address"]["city"]

        birthdate = subscriber["birthDate"]

        writer.writerow(
            [
                name,
                row["count"],
                address,
                postal_code,
                city,
                "",
                row["email"],
                birthdate,
                row["sum"],
            ]
        )
