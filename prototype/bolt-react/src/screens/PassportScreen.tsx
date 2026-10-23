import { useApp } from '../store';
import { BottomNav } from '../components/BottomNav';
import { AppBar } from '../components/AppBar';
import { Waves, HandHeart, TreePine, Utensils, Droplets, Award, Lock } from 'lucide-react';

const iconMap: Record<string, typeof Waves> = {
  waves: Waves,
  'hand-heart': HandHeart,
  'tree-pine': TreePine,
  utensils: Utensils,
  droplets: Droplets,
  award: Award,
};

export function PassportScreen() {
  const { data } = useApp();
  const progress = (data.missionsCompleted / data.missionsTotal) * 100;

  return (
    <div className="flex flex-col min-h-full bg-[#F8FAF8] dark:bg-primary-900">
      <AppBar title="Passaporte Verde" />

      <div className="flex-1 px-5 py-5 overflow-y-auto no-scrollbar pb-4">
        {/* Progress card */}
        <div className="bg-gradient-to-br from-primary-600 to-accent-500 rounded-3xl p-5 text-white mb-5 shadow-xl shadow-primary-600/20">
          <div className="flex items-center gap-2 mb-1">
            <Waves size={18} className="text-white/80" />
            <span className="text-xs font-bold uppercase tracking-wider text-white/80">
              Passaporte Verde Comunitário
            </span>
          </div>
          <h2 className="font-heading text-2xl font-extrabold mb-3">
            {data.missionsCompleted} de {data.missionsTotal} Missões Concluídas
          </h2>
          <div className="h-3 bg-white/20 rounded-full overflow-hidden mb-2">
            <div
              className="h-full bg-white rounded-full transition-all duration-500"
              style={{ width: `${progress}%` }}
            />
          </div>
          <p className="text-xs text-white/70">
            Continue explorando para conquistar todos os selos culturais!
          </p>
        </div>

        {/* Badges grid */}
        <h3 className="font-heading font-bold text-sm text-primary-700 dark:text-white mb-3">
          Selos Culturais
        </h3>
        <div className="grid grid-cols-2 gap-3">
          {data.badges.map((badge) => {
            const Icon = iconMap[badge.icon] || Award;
            return (
              <div
                key={badge.id}
                className={`rounded-2xl p-4 border transition-all ${
                  badge.earned
                    ? 'bg-white dark:bg-surface-dark border-accent-200 dark:border-accent-800 shadow-sm'
                    : 'bg-gray-50 dark:bg-primary-800/50 border-gray-200 dark:border-primary-700 opacity-60'
                }`}
              >
                <div
                  className={`w-12 h-12 rounded-2xl flex items-center justify-center mb-2.5 ${
                    badge.earned
                      ? 'bg-accent-500/15 text-accent-600 dark:text-accent-300'
                      : 'bg-gray-200 dark:bg-primary-700 text-gray-400 dark:text-gray-600'
                  }`}
                >
                  {badge.earned ? <Icon size={24} /> : <Lock size={20} />}
                </div>
                <p
                  className={`font-bold text-xs mb-1 ${
                    badge.earned
                      ? 'text-primary-700 dark:text-white'
                      : 'text-gray-400 dark:text-gray-500'
                  }`}
                >
                  {badge.name}
                </p>
                <p
                  className={`text-[10px] leading-relaxed ${
                    badge.earned
                      ? 'text-gray-500 dark:text-gray-400'
                      : 'text-gray-400 dark:text-gray-600'
                  }`}
                >
                  {badge.description}
                </p>
                {badge.earned && (
                  <div className="mt-2 inline-flex items-center gap-1 bg-accent-500/10 rounded-full px-2 py-0.5">
                    <span className="text-[9px] font-bold text-accent-600 dark:text-accent-300 uppercase">
                      Conquistado
                    </span>
                  </div>
                )}
                {!badge.earned && (
                  <div className="mt-2 inline-flex items-center gap-1 bg-gray-200 dark:bg-primary-700 rounded-full px-2 py-0.5">
                    <span className="text-[9px] font-bold text-gray-400 dark:text-gray-500 uppercase">
                      Pendente
                    </span>
                  </div>
                )}
              </div>
            );
          })}
        </div>
      </div>

      <BottomNav />
    </div>
  );
}
