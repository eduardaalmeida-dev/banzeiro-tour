import { useApp } from '../store';
import { BottomNav } from '../components/BottomNav';
import { AppBar } from '../components/AppBar';
import { Button } from '../components/Button';
import { Waves, Star, Ticket, BookOpen, LogOut, ChevronRight, BadgeCheck } from 'lucide-react';

export function ProfileScreen() {
  const { data, logout, setScreen } = useApp();

  return (
    <div className="flex flex-col min-h-full bg-[#F8FAF8] dark:bg-primary-900">
      <AppBar title="Perfil" />

      <div className="flex-1 px-5 py-5 overflow-y-auto no-scrollbar pb-4">
        {/* Profile header */}
        <div className="bg-white dark:bg-surface-dark rounded-3xl p-5 border border-gray-100 dark:border-primary-800 mb-5 text-center">
          <div className="w-20 h-20 rounded-full bg-gradient-to-br from-primary-600 to-accent-500 flex items-center justify-center mx-auto mb-3 shadow-lg">
            <Waves size={36} className="text-white" />
          </div>
          <h2 className="font-heading text-lg font-extrabold text-primary-700 dark:text-white">
            Turista Ecoturista
          </h2>
          <div className="inline-flex items-center gap-1 mt-1.5 bg-accent-50 dark:bg-accent-900/20 rounded-full px-3 py-1">
            <BadgeCheck size={12} className="text-accent-500" />
            <span className="text-xs font-bold text-accent-600 dark:text-accent-300">
              Cadastur Verificado
            </span>
          </div>
        </div>

        {/* Stats */}
        <div className="grid grid-cols-3 gap-3 mb-5">
          <div className="bg-white dark:bg-surface-dark rounded-2xl p-4 text-center border border-gray-100 dark:border-primary-800">
            <Ticket size={22} className="text-accent-500 mx-auto mb-1.5" />
            <p className="font-heading text-xl font-extrabold text-primary-700 dark:text-white">
              {data.vouchers.length}
            </p>
            <p className="text-[10px] text-gray-400 dark:text-gray-500 font-semibold uppercase">
              Vouchers
            </p>
          </div>
          <div className="bg-white dark:bg-surface-dark rounded-2xl p-4 text-center border border-gray-100 dark:border-primary-800">
            <Star size={22} className="text-warning-500 mx-auto mb-1.5" />
            <p className="font-heading text-xl font-extrabold text-primary-700 dark:text-white">
              {data.missionsCompleted}
            </p>
            <p className="text-[10px] text-gray-400 dark:text-gray-500 font-semibold uppercase">
              Selos
            </p>
          </div>
          <div className="bg-white dark:bg-surface-dark rounded-2xl p-4 text-center border border-gray-100 dark:border-primary-800">
            <BookOpen size={22} className="text-accent-500 mx-auto mb-1.5" />
            <p className="font-heading text-xl font-extrabold text-primary-700 dark:text-white">
              {data.experiences.length}
            </p>
            <p className="text-[10px] text-gray-400 dark:text-gray-500 font-semibold uppercase">
              Experiências
            </p>
          </div>
        </div>

        {/* Menu */}
        <div className="bg-white dark:bg-surface-dark rounded-2xl border border-gray-100 dark:border-primary-800 overflow-hidden mb-5">
          <button
            onClick={() => setScreen('passport')}
            className="w-full flex items-center gap-3 px-4 py-4 hover:bg-gray-50 dark:hover:bg-primary-800/50 transition-colors"
          >
            <BookOpen size={20} className="text-accent-500" />
            <span className="text-sm font-semibold text-primary-700 dark:text-white flex-1 text-left">
              Meu Passaporte Verde
            </span>
            <ChevronRight size={18} className="text-gray-300 dark:text-gray-600" />
          </button>
          <div className="h-px bg-gray-100 dark:bg-primary-800" />
          <button
            onClick={() => setScreen('voucher')}
            className="w-full flex items-center gap-3 px-4 py-4 hover:bg-gray-50 dark:hover:bg-primary-800/50 transition-colors"
          >
            <Ticket size={20} className="text-accent-500" />
            <span className="text-sm font-semibold text-primary-700 dark:text-white flex-1 text-left">
              Meus Vouchers
            </span>
            <ChevronRight size={18} className="text-gray-300 dark:text-gray-600" />
          </button>
        </div>

        <Button variant="outline" fullWidth icon={<LogOut size={18} />} onClick={logout}>
          Sair da Conta
        </Button>
      </div>

      <BottomNav />
    </div>
  );
}
