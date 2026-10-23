import { useState } from 'react';
import { useApp } from '../store';
import { BottomNav } from '../components/BottomNav';
import { Star, MapPin, Search, Waves } from 'lucide-react';
import type { Category } from '../types';

const categories: { key: Category; label: string }[] = [
  { key: 'todos', label: 'Todos' },
  { key: 'barcos', label: 'Barcos Fluviais' },
  { key: 'trilhas', label: 'Trilhas na Selva' },
  { key: 'artesanato', label: 'Artesanato' },
  { key: 'culinaria', label: 'Culinária' },
];

export function CatalogScreen() {
  const { data, selectExperience } = useApp();
  const [activeCat, setActiveCat] = useState<Category>('todos');
  const [search, setSearch] = useState('');

  const filtered = data.experiences.filter((e) => {
    const catMatch = activeCat === 'todos' || e.category === activeCat;
    const searchMatch =
      !search ||
      e.title.toLowerCase().includes(search.toLowerCase()) ||
      e.providerName.toLowerCase().includes(search.toLowerCase());
    return catMatch && searchMatch;
  });

  return (
    <div className="flex flex-col min-h-full bg-[#F8FAF8] dark:bg-primary-900">
      {/* Top bar */}
      <div className="bg-white dark:bg-surface-dark px-4 pt-12 pb-4 sticky top-0 z-30">
        <div className="flex items-center gap-2 mb-3">
          <MapPin size={16} className="text-accent-500" />
          <span className="text-sm font-bold text-primary-700 dark:text-white">RDS Rio Negro, AM</span>
          <div className="ml-auto flex items-center gap-1.5">
            <Waves size={14} className="text-accent-500" />
            <span className="text-xs text-gray-500 dark:text-gray-400 font-semibold">Online</span>
          </div>
        </div>
        <div className="relative">
          <Search size={18} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-400" />
          <input
            type="text"
            placeholder="Buscar experiências..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="w-full bg-gray-100 dark:bg-primary-800 rounded-2xl pl-11 pr-4 py-3 text-sm text-gray-700 dark:text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-accent-400 transition-all min-h-[44px]"
          />
        </div>
      </div>

      {/* Category filters */}
      <div className="px-4 py-3 overflow-x-auto no-scrollbar">
        <div className="flex gap-2 w-max">
          {categories.map((cat) => (
            <button
              key={cat.key}
              onClick={() => setActiveCat(cat.key)}
              className={`px-4 py-2 rounded-full text-xs font-bold whitespace-nowrap transition-all min-h-[40px] ${
                activeCat === cat.key
                  ? 'bg-accent-500 text-white shadow-lg shadow-accent-500/20 scale-105'
                  : 'bg-white dark:bg-surface-dark text-gray-600 dark:text-gray-300 border border-gray-200 dark:border-primary-700'
              }`}
            >
              {cat.label}
            </button>
          ))}
        </div>
      </div>

      {/* Feed */}
      <div className="flex-1 px-4 pb-4 space-y-4">
        {filtered.length === 0 && (
          <div className="text-center py-16 text-gray-400 dark:text-gray-500">
            <p className="text-sm font-semibold">Nenhuma experiência encontrada</p>
          </div>
        )}
        {filtered.map((exp) => (
          <button
            key={exp.id}
            onClick={() => selectExperience(exp.id)}
            className="w-full bg-white dark:bg-surface-dark rounded-2xl overflow-hidden shadow-sm border border-gray-100 dark:border-primary-800 text-left transition-all duration-200 hover:shadow-lg hover:-translate-y-0.5 active:scale-[0.98] animate-fade-in"
          >
            <div className="relative h-44 overflow-hidden">
              <img src={exp.image} alt={exp.title} className="w-full h-full object-cover" />
              <div className="absolute top-3 right-3 bg-white/95 backdrop-blur-sm rounded-full px-2.5 py-1 flex items-center gap-1 shadow-md">
                <Star size={12} className="text-warning-500 fill-warning-500" />
                <span className="text-xs font-bold text-primary-700">{exp.rating}</span>
              </div>
              <div className="absolute bottom-3 left-3 bg-primary-600/90 backdrop-blur-sm rounded-full px-3 py-1">
                <span className="text-xs font-bold text-white">{exp.community}</span>
              </div>
            </div>
            <div className="p-4">
              <h3 className="font-heading font-bold text-base text-primary-700 dark:text-white mb-1 line-clamp-1">
                {exp.title}
              </h3>
              <p className="text-xs text-gray-500 dark:text-gray-400 mb-3">
                {exp.providerName}
              </p>
              <div className="flex items-end justify-between">
                <div>
                  <span className="font-heading text-xl font-extrabold text-accent-600 dark:text-accent-300">
                    R$ {exp.price}
                  </span>
                  <span className="text-xs text-gray-400 dark:text-gray-500 ml-1">/{exp.priceUnit}</span>
                </div>
                <div className="flex items-center gap-1 text-xs text-gray-400 dark:text-gray-500">
                  <Star size={12} className="fill-warning-500 text-warning-500" />
                  <span className="font-semibold">{exp.reviews} avaliações</span>
                </div>
              </div>
            </div>
          </button>
        ))}
      </div>

      <BottomNav />
    </div>
  );
}
