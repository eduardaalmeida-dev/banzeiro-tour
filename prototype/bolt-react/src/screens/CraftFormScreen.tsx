import { useState } from 'react';
import { useApp } from '../store';
import { AppBar } from '../components/AppBar';
import { Button } from '../components/Button';
import { Camera, Gem, Check } from 'lucide-react';

const materials = ['Sementes Naturais', 'Madeira Caída', 'Fibra de Arumã'] as const;

export function CraftFormScreen() {
  const { addCraft, setScreen } = useApp();
  const [name, setName] = useState('');
  const [material, setMaterial] = useState<(typeof materials)[number] | ''>('');
  const [quantity, setQuantity] = useState(1);
  const [price, setPrice] = useState('');
  const [photoTaken, setPhotoTaken] = useState(false);

  const handleSubmit = () => {
    if (!name || !material || !price) return;
    addCraft({
      id: crypto.randomUUID(),
      name,
      material,
      quantity,
      price: Number(price),
      image: photoTaken
        ? 'https://images.pexels.com/photos/10491415/pexels-photo-10491415.jpeg?auto=compress&cs=tinysrgb&h=400&w=400'
        : 'https://images.pexels.com/photos/10596300/pexels-photo-10596300.jpeg?auto=compress&cs=tinysrgb&h=400&w=400',
    });
    setScreen('artesa');
  };

  return (
    <div className="flex flex-col min-h-full bg-[#F8FAF8] dark:bg-primary-900">
      <AppBar title="Nova Peça de Artesanato" showBack onBack={() => setScreen('artesa')} />

      <div className="flex-1 px-5 py-5 overflow-y-auto no-scrollbar">
        <div className="space-y-4">
          {/* Foto */}
          <div>
            <label className="text-xs font-bold text-gray-500 dark:text-gray-400 uppercase mb-2 block">
              Foto da Peça
            </label>
            <button
              onClick={() => setPhotoTaken(true)}
              className="w-full bg-white dark:bg-surface-dark rounded-2xl p-6 border-2 border-dashed border-accent-300 dark:border-accent-700 flex flex-col items-center justify-center gap-2 text-accent-600 dark:text-accent-300 hover:bg-accent-50 dark:hover:bg-accent-900/20 transition-colors min-h-[120px]"
            >
              {photoTaken ? (
                <>
                  <Check size={28} className="text-success-500" />
                  <span className="font-bold text-sm text-success-600 dark:text-success-400">
                    Foto Capturada!
                  </span>
                </>
              ) : (
                <>
                  <Camera size={28} />
                  <span className="font-bold text-sm">Fotografar Peça com a Câmera</span>
                </>
              )}
            </button>
          </div>

          {/* Nome */}
          <div>
            <label className="text-xs font-bold text-gray-500 dark:text-gray-400 uppercase mb-2 block">
              Nome da Peça
            </label>
            <div className="relative">
              <Gem size={18} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-400" />
              <input
                type="text"
                placeholder="ex: Colar de Jarina"
                value={name}
                onChange={(e) => setName(e.target.value)}
                className="w-full bg-white dark:bg-surface-dark rounded-2xl pl-11 pr-4 py-3.5 text-sm text-primary-700 dark:text-white border border-gray-200 dark:border-primary-700 focus:outline-none focus:ring-2 focus:ring-accent-400 placeholder-gray-400 min-h-[48px]"
              />
            </div>
          </div>

          {/* Matéria-prima */}
          <div>
            <label className="text-xs font-bold text-gray-500 dark:text-gray-400 uppercase mb-2 block">
              Matéria-prima
            </label>
            <div className="flex flex-wrap gap-2">
              {materials.map((m) => (
                <button
                  key={m}
                  onClick={() => setMaterial(m)}
                  className={`px-4 py-2.5 rounded-full text-xs font-bold transition-all min-h-[44px] ${
                    material === m
                      ? 'bg-accent-500 text-white shadow-lg shadow-accent-500/20 scale-105'
                      : 'bg-white dark:bg-surface-dark text-gray-500 dark:text-gray-400 border border-gray-200 dark:border-primary-700'
                  }`}
                >
                  {m}
                </button>
              ))}
            </div>
          </div>

          {/* Quantidade */}
          <div>
            <label className="text-xs font-bold text-gray-500 dark:text-gray-400 uppercase mb-2 block">
              Quantidade
            </label>
            <div className="flex items-center gap-3">
              <button
                onClick={() => setQuantity((v) => Math.max(1, v - 1))}
                className="w-12 h-12 rounded-2xl bg-white dark:bg-surface-dark border border-gray-200 dark:border-primary-700 flex items-center justify-center text-primary-600 dark:text-accent-300 text-xl font-bold hover:bg-gray-50 dark:hover:bg-primary-800 transition-colors"
              >
                −
              </button>
              <div className="flex-1 bg-white dark:bg-surface-dark rounded-2xl py-3.5 text-center border border-gray-200 dark:border-primary-700">
                <span className="font-heading text-xl font-extrabold text-primary-700 dark:text-white">
                  {quantity}
                </span>
              </div>
              <button
                onClick={() => setQuantity((v) => Math.min(99, v + 1))}
                className="w-12 h-12 rounded-2xl bg-white dark:bg-surface-dark border border-gray-200 dark:border-primary-700 flex items-center justify-center text-primary-600 dark:text-accent-300 text-xl font-bold hover:bg-gray-50 dark:hover:bg-primary-800 transition-colors"
              >
                +
              </button>
            </div>
          </div>

          {/* Preço */}
          <div>
            <label className="text-xs font-bold text-gray-500 dark:text-gray-400 uppercase mb-2 block">
              Preço (R$)
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
          Colocar na Vitrine Comunitária
        </Button>
      </div>
    </div>
  );
}
