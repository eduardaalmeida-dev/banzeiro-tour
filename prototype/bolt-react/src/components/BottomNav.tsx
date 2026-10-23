import { Compass, BookOpen, Ticket, User } from 'lucide-react';
import { useApp } from '../store';
import type { Screen } from '../types';

const navItems: { screen: Screen; label: string; icon: typeof Compass }[] = [
  { screen: 'catalog', label: 'Explorar', icon: Compass },
  { screen: 'passport', label: 'Passaporte', icon: BookOpen },
  { screen: 'voucher', label: 'Meu Voucher', icon: Ticket },
  { screen: 'profile', label: 'Perfil', icon: User },
];

export function BottomNav() {
  const { screen, setScreen } = useApp();

  return (
    <div className="sticky bottom-0 left-0 right-0 bg-white dark:bg-surface-dark border-t border-gray-100 dark:border-primary-800 px-2 py-1.5 pb-3 z-40">
      <div className="flex items-center justify-around">
        {navItems.map(({ screen: s, label, icon: Icon }) => {
          const active = screen === s;
          return (
            <button
              key={s}
              onClick={() => setScreen(s)}
              className="flex flex-col items-center justify-center gap-0.5 min-w-[64px] min-h-[48px] transition-colors"
            >
              <div
                className={`p-1.5 rounded-xl transition-all duration-200 ${
                  active
                    ? 'bg-accent-500/15 text-accent-600 dark:text-accent-300'
                    : 'text-gray-400 dark:text-gray-500'
                }`}
              >
                <Icon size={22} strokeWidth={active ? 2.5 : 2} />
              </div>
              <span
                className={`text-[10px] font-semibold transition-colors ${
                  active ? 'text-accent-600 dark:text-accent-300' : 'text-gray-400 dark:text-gray-500'
                }`}
              >
                {label}
              </span>
            </button>
          );
        })}
      </div>
    </div>
  );
}
