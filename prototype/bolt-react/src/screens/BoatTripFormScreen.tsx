import { useState } from 'react';
import { useApp } from '../store';
import { AppBar } from '../components/AppBar';
import { Button } from '../components/Button';
import { Ship, Minus, Plus, MapPin } from 'lucide-react';

export function BoatTripFormScreen() {
  const { addBoatTrip, setScreen } = useApp();
  const [boat, setBoat] = useState('Voadeira Rio Negro II');
  const [origin, setOrigin] = useState('');
  const [destination, setDestination] = useState('');
  const [departure, setDeparture] = useState('08:30');
  const [maxCapacity, setMaxCapacity] = useState(8);
  const [price, setPrice] = useState('');

  const adjustTime = (delta: number) => {
    const [h, m] = departure.split(':').map(Number);
    let total = h * 60 + m + delta * 30;
    total = Math.max(0, Math.min(23 * 60 + 30, total));
    const nh = Math.floor(total / 60);
    const nm = total % 60;
    setDeparture(`${String(nh).padStart(2, '0')}:${String(nm).padStart(2, '0')}`);
  };

  const handleSubmit = () => {
    if (!origin || !destination || !price) return;
    addBoatTrip({
      id: crypto.randomUUID(),
      boat,
      route: `${origin} → ${destination}`,
      departure,
      maxCapacity,
      booked: 0,
      pricePerSeat: Number(price),
    });
    setScreen('barqueiro');
  };

  return (
    <div className="flex flex-col min-h-full bg-[#F8FAF8] dark:bg-primary-900">
      <AppBar
        title="Nova Saída de Barco"
        showBack
        onBack={() => setScreen('barqueiro')}
      />

      <div className="flex-1 px-5 py-5 overflow-y-auto no-scrollbar">
        <div className="space-y-4">
          {/* Embarcação */}
          <div>
            <label className="text-xs font-bold text-gray-500 dark:text-gray-400 uppercase mb-2 block">
              Embarcação
            </label>
            <div className="relative">
              <Ship size={18} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-400" />
              <input
                type="text"
                value={boat}
                onChange={(e) => setBoat(e.target.value)}
                className="w-full bg-white dark:bg-surface-dark rounded-2xl pl-11 pr-4 py-3.5 text-sm text-primary-700 dark:text-white border border-gray-200 dark:border-primary-700 focus:outline-none focus:ring-2 focus:ring-accent-400 min-h-[48px]"
              />
            </div>
          </div>

          {/* Trecho */}
          <div>
            <label className="text-xs font-bold text-gray-500 dark:text-gray-400 uppercase mb-2 block">
              Trecho Fluvial
            </label>
            <div className="space-y-2">
              <div className="relative">
                <MapPin size={18} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-accent-500" />
                <input
                  type="text"
                  placeholder="Origem (ex: Manaus)"
                  value={origin}
                  onChange={(e) => setOrigin(e.target.value)}
                  className="w-full bg-white dark:bg-surface-dark rounded-2xl pl-11 pr-4 py-3.5 text-sm text-primary-700 dark:text-white border border-gray-200 dark:border-primary-700 focus:outline-none focus:ring-2 focus:ring-accent-400 placeholder-gray-400 min-h-[48px]"
                />
              </div>
              <div className="relative">
                <MapPin size={18} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-error-400" />
                <input
                  type="text"
                  placeholder="Destino (ex: Tumbira)"
                  value={destination}
                  onChange={(e) => setDestination(e.target.value)}
                  className="w-full bg-white dark:bg-surface-dark rounded-2xl pl-11 pr-4 py-3.5 text-sm text-primary-700 dark:text-white border border-gray-200 dark:border-primary-700 focus:outline-none focus:ring-2 focus:ring-accent-400 placeholder-gray-400 min-h-[48px]"
                />
              </div>
            </div>
          </div>

          {/* Horário */}
          <div>
            <label className="text-xs font-bold text-gray-500 dark:text-gray-400 uppercase mb-2 block">
              Horário de Partida
            </label>
            <div className="flex items-center gap-3">
              <button
                onClick={() => adjustTime(-1)}
                className="w-12 h-12 rounded-2xl bg-white dark:bg-surface-dark border border-gray-200 dark:border-primary-700 flex items-center justify-center text-primary-600 dark:text-accent-300 hover:bg-gray-50 dark:hover:bg-primary-800 transition-colors"
              >
                <Minus size={20} />
              </button>
              <div className="flex-1 bg-white dark:bg-surface-dark rounded-2xl py-3.5 text-center border border-gray-200 dark:border-primary-700">
                <span className="font-heading text-xl font-extrabold text-primary-700 dark:text-white">
                  {departure}
                </span>
              </div>
              <button
                onClick={() => adjustTime(1)}
                className="w-12 h-12 rounded-2xl bg-white dark:bg-surface-dark border border-gray-200 dark:border-primary-700 flex items-center justify-center text-primary-600 dark:text-accent-300 hover:bg-gray-50 dark:hover:bg-primary-800 transition-colors"
              >
                <Plus size={20} />
              </button>
            </div>
          </div>

          {/* Lotação */}
          <div>
            <label className="text-xs font-bold text-gray-500 dark:text-gray-400 uppercase mb-2 block">
              Lotação Máxima (máx. 12)
            </label>
            <div className="flex items-center gap-3">
              <button
                onClick={() => setMaxCapacity((v) => Math.max(1, v - 1))}
                className="w-12 h-12 rounded-2xl bg-white dark:bg-surface-dark border border-gray-200 dark:border-primary-700 flex items-center justify-center text-primary-600 dark:text-accent-300 hover:bg-gray-50 dark:hover:bg-primary-800 transition-colors"
              >
                <Minus size={20} />
              </button>
              <div className="flex-1 bg-white dark:bg-surface-dark rounded-2xl py-3.5 text-center border border-gray-200 dark:border-primary-700">
                <span className="font-heading text-xl font-extrabold text-primary-700 dark:text-white">
                  {maxCapacity}
                </span>
                <span className="text-sm text-gray-400 dark:text-gray-500 ml-1">pessoas</span>
              </div>
              <button
                onClick={() => setMaxCapacity((v) => Math.min(12, v + 1))}
                className="w-12 h-12 rounded-2xl bg-white dark:bg-surface-dark border border-gray-200 dark:border-primary-700 flex items-center justify-center text-primary-600 dark:text-accent-300 hover:bg-gray-50 dark:hover:bg-primary-800 transition-colors"
              >
                <Plus size={20} />
              </button>
            </div>
          </div>

          {/* Preço */}
          <div>
            <label className="text-xs font-bold text-gray-500 dark:text-gray-400 uppercase mb-2 block">
              Valor por Assento (R$)
            </label>
            <div className="relative">
              <span className="absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-400 font-bold text-sm">R$</span>
              <input
                type="number"
                placeholder="0,00"
                value={price}
                onChange={(e) => setPrice(e.target.value)}
                className="w-full bg-white dark:bg-surface-dark rounded-2xl pl-11 pr-4 py-3.5 text-sm text-primary-700 dark:text-white border border-gray-200 dark:border-primary-700 focus:outline-none focus:ring-2 focus:ring-accent-400 placeholder-gray-400 min-h-[48px]"
              />
            </div>
          </div>
        </div>
      </div>

      <div className="sticky bottom-0 bg-white dark:bg-surface-dark border-t border-gray-100 dark:border-primary-800 px-5 py-4 pb-6">
        <Button variant="accent" fullWidth size="lg" onClick={handleSubmit}>
          Confirmar Saída (Salvar Offline)
        </Button>
      </div>
    </div>
  );
}
