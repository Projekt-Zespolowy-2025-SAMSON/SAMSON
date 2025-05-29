import matplotlib.pyplot as plt

# Wczytaj dane z pliku
x = []
y = []
x_val = 0

with open("EMG2_2205154544.txt", "r") as file:
    for line in file:
        x_val += 1
        parts = line.strip().split()
        if len(parts) == 1:
            y_val = float(parts[0])  # <- poprawka tutaj
            x.append(x_val)
            y.append(y_val)

# Rysowanie wykresu
plt.figure(figsize=(8, 5))
plt.plot(x, y, marker='o', linestyle='-', color='b', label='Dane z pliku')
plt.title('Wykres na podstawie pliku tekstowego')
plt.xlabel('Oś X')
plt.ylabel('Oś Y')
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.show()
