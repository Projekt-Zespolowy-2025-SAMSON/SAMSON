import matplotlib.pyplot as plt

x = []
ch1_vals = []
ch2_vals = []
x_val = 0

name = 'EMG_2106194427.txt'  

with open(name, "r") as file:
    for line in file:
        parts = line.strip().split(';')
        if len(parts) == 2:
            x_val += 1
            try:
                ch1 = int(parts[0])
                ch2 = int(parts[1])
                x.append(x_val)
                ch1_vals.append(ch1)
                ch2_vals.append(ch2)
            except ValueError:
                print(f"Błąd konwersji w linii: {line.strip()}")

plt.figure(figsize=(10, 6))
plt.plot(x, ch1_vals, marker='', linestyle='-', color='blue', label='Kanał 1')
plt.plot(x, ch2_vals, marker='', linestyle='-', color='red', label='Kanał 2')
plt.title(f'Dane EMG z pliku: {name}')
plt.xlabel('Próbki')
plt.ylabel('Wartości ADC')
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.show()
