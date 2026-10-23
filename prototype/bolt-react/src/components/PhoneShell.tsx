import type { ReactNode } from 'react';
import { useApp } from '../store';
import { Sun, Moon } from 'lucide-react';
import type { Role } from '../types';

const roleLabels: Record<Role, string> = {
  turista: 'Turista',
  barqueiro: 'Barqueiro',
  guia: 'Guia',
  artesa: 'Artesã',
  cozinheira: 'Cozinheira',
};

const roleColors: Record<Role, string> = {
  turista: 'bg-accent-500 text-white',
  barqueiro: 'bg-secondary-500 text-white',
  guia: 'bg-primary-600 text-white',
  artesa: 'bg-warning-600 text-white',
  cozinheira: 'bg-error-500 text-white',
};

export function PhoneShell({ children }: { children: ReactNode }) {
  const { data, setRole, toggleTheme } = useApp();

  return (
    <div className="min-h-screen bg-gradient-to-br from-primary-900 via-primary-800 to-primary-700 flex flex-col items-center py-6 px-4">
      {/* Top toolbar */}
      <div className="w-full max-w-[420px] mb-4 flex items-center justify-between gap-3">
        <div className="flex items-center gap-2 flex-wrap">
          <span className="text-white/70 text-xs font-semibold uppercase tracking-wider hidden sm:inline">Perfil:</span>
          {(Object.keys(roleLabels) as Role[]).map((r) => (
            <button
              key={r}
              onClick={() => setRole(r)}
              className={`px-3 py-1.5 rounded-full text-xs font-bold transition-all duration-200 ${
                data.currentRole === r
                  ? `${roleColors[r]} shadow-lg scale-105`
                  : 'bg-white/10 text-white/70 hover:bg-white/20'
              }`}
            >
              {roleLabels[r]}
            </button>
          ))}
        </div>
        <button
          onClick={toggleTheme}
          className="flex items-center justify-center w-10 h-10 rounded-full bg-white/10 text-white hover:bg-white/20 transition-colors shrink-0"
          aria-label="Alternar tema"
        >
          {data.theme === 'light' ? <Moon size={18} /> : <Sun size={18} />}
        </button>
      </div>

      {/* Phone mockup */}
      <div className="relative w-full max-w-[420px] h-[860px] rounded-[2.5rem] border-8 border-gray-900 shadow-2xl overflow-hidden bg-white dark:bg-surface-dark">
        <div className="absolute top-0 left-1/2 -translate-x-1/2 w-32 h-6 bg-gray-900 rounded-b-2xl z-50" />
        <div className="w-full h-full overflow-y-auto no-scrollbar">{children}</div>
      </div>
    </div>
  );
}
