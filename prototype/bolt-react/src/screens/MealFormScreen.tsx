import { useState } from 'react';
import { useApp } from '../store';
import { AppBar } from '../components/AppBar';
import { Button } from '../components/Button';
import { Utensils, Clock } from 'lucide-react';

const mealTypes = ['Café Regional', 'Almoço da Floresta', 'Merenda'] as const;

export function MealFormScreen() {
  const { addMeal, setScreen } = useApp();
  const [type, setType] = useState<(typeof mealTypes)[number]>('Almoço da Floresta');
  const [name, setName] = useState('');
  const [windowStart, setWindowStart] = useState('11:30');
  const [windowEnd, setWindowEnd] = useState('13:30');
  const [maxPortions, setMaxPortions] = useState(20);
  const [price, setPrice] = useState('');

  const handleSubmit = () => {
    if (!name || !price) return;
    addMeal({
      id: crypto.randomUUID(),
      type,
      name,
      window: `${windowStart} às ${windowEnd}`,
      maxPortions,
      reserved: 0,
      price: Number(price),
    });
    setScreen('cozinheira');
  };

  return (
    <div className="flex flex-col min-h-full bg-[#F8FAF8] dark:bg-primary-900">
      <AppBar title="Nova Refeição" showBack onBack={() => setScreen('cozinheira')} />

      <div className="flex-1 px-5 py-5 overflow-y-auto no-scrollbar">
        <div className="space-y-4">
          {/* Tipo */}
          <div>
            <label className="text-xs font-bold text-gray-500 dark:text-gray-400 uppercase mb-2 block">
              Tipo de Refeição
            </label>
            <div className="grid grid-cols-1 gap-2">
              {mealTypes.map((t) => (
                <button
                  key={t}
                  onClick={() => setType(t)}
                  className={`py-3 px-4 rounded-2xl text-sm font-bold transition-all min-h-[48px] flex items-center gap-2 ${
                    type === t
                      ? 'bg-accent-500 text-white shadow-lg shadow-accent-500/20'
                      : 'bg-white dark:bg-surface-dark text-gray-500 dark:text-gray-400 border border-gray-200 dark:border-primary-700'
                  }`}
                >
                  <Utensils size={16} />
                  {t}
                </button>
              ))}
            </div>
          </div>

          {/* Nome do prato */}
          <div>
            <label className="text-xs font-bold text-gray-500 dark:text-gray-400 uppercase mb-2 block">
              Nome do Prato
            </label>
            <div className="relative">
              <Utensils size={18} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-400" />
              <input
                type="text"
                placeholder="ex: Peixe Moqueado com Farinha"
                value={name}
                onChange={(e) => setName(e.target.value)}
                className="w-full bg-white dark:bg-surface-dark rounded-2xl pl-11 pr-4 py-3.5 text-sm text-primary-700 dark:text-white border border-gray-200 dark:border-primary-700 focus:outline-none focus:ring-2 focus:ring-accent-400 placeholder-gray-400 min-h-[48px]"
              />
            </div>
          </div>

          {/* Janela de atendimento */}
          <div>
            <label className="text-xs font-bold text-gray-500 dark:text-gray-400 uppercase mb-2 block">
              Janela de Atendimento
            </label>
            <div className="flex items-center gap-3">
              <div className="relative flex-1">
                <Clock size={18} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-400" />
                <input
                  type="time"
                  value={windowStart}
                  onChange={(e) => setWindowStart(e.target.value)}
                  className="w-full bg-white dark:bg-surface-dark rounded-2xl pl-11 pr-4 py-3.5 text-sm text-primary-700 dark:text-white border border-gray-200 dark:border-primary-700 focus:outline-none focus:ring-2 focus:ring-accent-400 min-h-[48px]"
                />
              </div>
              <span className="text-gray-400 font-bold">→</span>
              <div className="relative flex-1">
                <Clock size={18} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-400" />
                <input
                  type="time"
                  value={windowEnd}
                  onChange={(e) => setWindowEnd(e.target.value)}
                  className="w-full bg-white dark:bg-surface-dark rounded-2xl pl-11 pr-4 py-3.5 text-sm text-primary-700 dark:text-white border border-gray-200 dark:border-primary-700 focus:outline-none focus:ring-2 focus:ring-accent-400 min-h-[48px]"
                />
              </div>
            </div>
          </div>

          {/* Limite de porções */}
          <div>
            <label className="text-xs font-bold text-gray-500 dark:text-gray-400 uppercase mb-2 block">
              Limite de Porções
            </label>
            <div className="flex items-center gap-3">
              <button
                onClick={() => setMaxPortions((v) => Math.max(1, v - 1))}
                className="w-12 h-12 rounded-2xl bg-white dark:bg-surface-dark border border-gray-200 dark:border-primary-700 flex items-center justify-center text-primary-600 dark:text-accent-300 text-xl font-bold hover:bg-gray-50 dark:hover:bg-primary-800 transition-colors"
              >
                −
              </button>
              <div className="flex-1 bg-white dark:bg-surface-dark rounded-2xl py-3.5 text-center border border-gray-200 dark:border-primary-700">
                <span className="font-heading text-xl font-extrabold text-primary-700 dark:text-white">
                  {maxPortions}
                </span>
                <span className="text-sm text-gray-400 dark:text-gray-500 ml-1">porções</span>
              </div>
              <button
                onClick={() => setMaxPortions((v) => Math.min(100, v + 1))}
                className="w-12 h-12 rounded-2xl bg-white dark:bg-surface-dark border border-gray-200 dark:border-primary-700 flex items-center justify-center text-primary-600 dark:text-accent-300 text-xl font-bold hover:bg-gray-50 dark:hover:bg-primary-800 transition-colors"
              >
                +
              </button>
            </div>
          </div>

          {/* Preço */}
          <div>
            <label className="text-xs font-bold text-gray-500 dark:text-gray-400 uppercase mb-2 block">
              Preço por Refeição (R$)
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
          Salvar Cardápio Comunitário
        </Button>
      </div>
    </div>
  );
}
