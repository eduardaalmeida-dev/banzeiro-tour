import { useApp } from '../store';
import { AppBar } from '../components/AppBar';
import { Button } from '../components/Button';
import { Utensils, Plus, Ship, Clock, Minus, Plus as PlusIcon } from 'lucide-react';

export function CozinheiraScreen() {
  const { data, setScreen, updateMealReserved } = useApp();

  return (
    <div className="flex flex-col min-h-full bg-[#F8FAF8] dark:bg-primary-900">
      <AppBar title="Painel da Cozinheira" />

      <div className="flex-1 px-5 py-5 overflow-y-auto no-scrollbar pb-4">
        {/* Header card */}
        <div className="bg-gradient-to-br from-error-500 to-error-700 rounded-3xl p-5 text-white mb-5 shadow-xl shadow-error-500/20">
          <div className="flex items-center gap-3 mb-4">
            <div className="w-12 h-12 rounded-2xl bg-white/20 flex items-center justify-center">
              <Utensils size={24} className="text-white" />
            </div>
            <div>
              <h2 className="font-heading font-bold text-base">Dona Antônia</h2>
              <p className="text-xs text-white/70">Cozinha Tradicional</p>
            </div>
          </div>
          {/* Sync banner */}
          <div className="bg-white/15 rounded-2xl p-3 flex items-start gap-2.5">
            <Ship size={18} className="text-white/80 mt-0.5 shrink-0" />
            <p className="text-xs font-medium leading-relaxed">
              Atracação prevista: Voadeira Rio Negro às 12:00 (6 almoços reservados)
            </p>
          </div>
        </div>

        {/* Primary action */}
        <Button
          variant="accent"
          fullWidth
          size="lg"
          icon={<Plus size={20} />}
          onClick={() => setScreen('mealForm')}
          className="mb-5"
        >
          PROGRAMAR REFEIÇÃO / CARDÁPIO
        </Button>

        {/* Today's menu */}
        <h3 className="font-heading font-bold text-sm text-primary-700 dark:text-white mb-3">
          Cardápio de Hoje
        </h3>
        <div className="space-y-3">
          {data.meals.map((meal) => {
            const pct = (meal.reserved / meal.maxPortions) * 100;
            return (
              <div
                key={meal.id}
                className="bg-white dark:bg-surface-dark rounded-2xl p-4 border border-gray-100 dark:border-primary-800"
              >
                <div className="flex items-start justify-between mb-2">
                  <div>
                    <span className="text-[10px] font-bold text-accent-600 dark:text-accent-300 uppercase">
                      {meal.type}
                    </span>
                    <p className="font-bold text-sm text-primary-700 dark:text-white mt-0.5">
                      {meal.name}
                    </p>
                  </div>
                  <span className="font-heading font-extrabold text-sm text-accent-600 dark:text-accent-300">
                    R$ {meal.price}
                  </span>
                </div>

                <div className="flex items-center gap-1.5 mb-3 text-xs text-gray-400 dark:text-gray-500">
                  <Clock size={12} />
                  <span>{meal.window}</span>
                </div>

                {/* Progress */}
                <div className="mb-3">
                  <div className="flex items-center justify-between mb-1.5">
                    <span className="text-xs font-semibold text-gray-500 dark:text-gray-400">
                      {meal.reserved} de {meal.maxPortions} pratos reservados
                    </span>
                    <span className="text-[10px] font-bold text-gray-400 dark:text-gray-500">
                      {pct.toFixed(0)}%
                    </span>
                  </div>
                  <div className="h-2 bg-gray-100 dark:bg-primary-800 rounded-full overflow-hidden">
                    <div
                      className={`h-full rounded-full transition-all duration-500 ${
                        pct >= 80 ? 'bg-error-500' : pct >= 50 ? 'bg-warning-500' : 'bg-accent-500'
                      }`}
                      style={{ width: `${pct}%` }}
                    />
                  </div>
                </div>

                {/* Counter */}
                <div className="flex items-center gap-2">
                  <button
                    onClick={() => updateMealReserved(meal.id, Math.max(0, meal.reserved - 1))}
                    className="w-10 h-10 rounded-xl bg-gray-100 dark:bg-primary-800 flex items-center justify-center text-primary-600 dark:text-accent-300 hover:bg-gray-200 dark:hover:bg-primary-700 transition-colors"
                  >
                    <Minus size={16} />
                  </button>
                  <span className="font-heading font-extrabold text-base text-primary-700 dark:text-white min-w-[40px] text-center">
                    {meal.reserved}
                  </span>
                  <button
                    onClick={() => updateMealReserved(meal.id, Math.min(meal.maxPortions, meal.reserved + 1))}
                    className="w-10 h-10 rounded-xl bg-gray-100 dark:bg-primary-800 flex items-center justify-center text-primary-600 dark:text-accent-300 hover:bg-gray-200 dark:hover:bg-primary-700 transition-colors"
                  >
                    <PlusIcon size={16} />
                  </button>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}
