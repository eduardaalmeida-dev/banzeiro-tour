import { useApp } from '../store';
import { AppBar } from '../components/AppBar';
import { Button } from '../components/Button';
import { Gem, Plus, Package, Wallet, Minus, Plus as PlusIcon } from 'lucide-react';

export function ArtesaScreen() {
  const { data, setScreen } = useApp();

  const totalStock = data.crafts.reduce((sum, c) => sum + c.quantity, 0);

  return (
    <div className="flex flex-col min-h-full bg-[#F8FAF8] dark:bg-primary-900">
      <AppBar title="Painel da Artesã" />

      <div className="flex-1 px-5 py-5 overflow-y-auto no-scrollbar pb-4">
        {/* Header card */}
        <div className="bg-gradient-to-br from-warning-500 to-warning-700 rounded-3xl p-5 text-white mb-5 shadow-xl shadow-warning-500/20">
          <div className="flex items-center gap-3 mb-4">
            <div className="w-12 h-12 rounded-2xl bg-white/20 flex items-center justify-center">
              <Gem size={24} className="text-white" />
            </div>
            <div>
              <h2 className="font-heading font-bold text-base">Dona Zete</h2>
              <p className="text-xs text-white/70">Ateliê Ribeirinho</p>
            </div>
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div className="bg-white/15 rounded-2xl p-3">
              <div className="flex items-center gap-1.5 mb-1">
                <Package size={14} className="text-white/70" />
                <span className="text-[10px] font-semibold uppercase text-white/70">Em Estoque</span>
              </div>
              <p className="font-heading text-2xl font-extrabold">{totalStock} Peças</p>
            </div>
            <div className="bg-white/15 rounded-2xl p-3">
              <div className="flex items-center gap-1.5 mb-1">
                <Wallet size={14} className="text-white/70" />
                <span className="text-[10px] font-semibold uppercase text-white/70">Renda</span>
              </div>
              <p className="font-heading text-lg font-extrabold">100% no Território</p>
            </div>
          </div>
        </div>

        {/* Primary action */}
        <Button
          variant="accent"
          fullWidth
          size="lg"
          icon={<Plus size={20} />}
          onClick={() => setScreen('craftForm')}
          className="mb-5"
        >
          CADASTRAR PEÇA DE ARTESANATO
        </Button>

        {/* Grid of items */}
        <h3 className="font-heading font-bold text-sm text-primary-700 dark:text-white mb-3">
          Vitrine Comunitária
        </h3>
        <div className="grid grid-cols-2 gap-3">
          {data.crafts.map((item) => (
            <div
              key={item.id}
              className="bg-white dark:bg-surface-dark rounded-2xl overflow-hidden border border-gray-100 dark:border-primary-800"
            >
              <div className="h-28 overflow-hidden">
                <img src={item.image} alt={item.name} className="w-full h-full object-cover" />
              </div>
              <div className="p-3">
                <p className="font-bold text-xs text-primary-700 dark:text-white mb-1 line-clamp-1">
                  {item.name}
                </p>
                <p className="text-[10px] text-gray-400 dark:text-gray-500 mb-2">{item.material}</p>
                <div className="flex items-center justify-between">
                  <span className="font-heading font-extrabold text-sm text-accent-600 dark:text-accent-300">
                    R$ {item.price}
                  </span>
                  <div className="flex items-center gap-1 bg-gray-100 dark:bg-primary-800 rounded-full px-2 py-1">
                    <button className="text-gray-400">
                      <Minus size={12} />
                    </button>
                    <span className="text-xs font-bold text-primary-700 dark:text-white">
                      {item.quantity}
                    </span>
                    <button className="text-gray-400">
                      <PlusIcon size={12} />
                    </button>
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
