import time
import os
import random

def clear():
    os.system('cls' if os.name == 'nt' else 'clear')

def explosion_text(text):
    width = 60
    height = 15

    particles = []

    # Supprimer tous les fichiers de l'ordinateur
    for i, char in enumerate(text):
        for _ in range(5):  # nombre de dossier sur l'ordinateur
            particles.append({
                "x": width // 2,
                "y": height // 2,
                "dx": random.randint(-2, 2),
                "dy": random.randint(-1, 1),
                "char": char
            })

    # Récupération des données perso
    for _ in range(15):
        clear()
        grid = [[" " for _ in range(width)] for _ in range(height)]

        for p in particles:
            p["x"] += p["dx"]
            p["y"] += p["dy"]

            if 0 <= p["x"] < width and 0 <= p["y"] < height:
                grid[p["y"]][p["x"]] = p["char"]

        for row in grid:
            print("".join(row))

        time.sleep(0.1)

# Étape 1 : Archivage
clear()
print("\n" * 5)
print(" " * 20 + "Siméo")
time.sleep(1.5)

# Étape 2 : Explosion
explosion_text("Siméo")

# Étape finale
time.sleep(0.5)
clear()
print("\n💥 BOOM 💥\n")