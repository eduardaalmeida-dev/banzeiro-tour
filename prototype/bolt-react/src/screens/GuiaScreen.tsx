import { useApp } from '../store';
import { AppBar } from '../components/AppBar';
import { Button } from '../components/Button';
import { Compass, Plus, Stamp, Mountain, Users, Clock } from 'lucide-react';

export function GuiaScreen() {
  const { data, setScreen } = useApp();

  return (
    <div className="flex flex-col min-h-full bg-[#F8FAF8] dark:bg-primary-900">
      <AppBar title="Painel do Guia" />

      <div className="flex-1 px-5 py-5 overflow-y-auto no-scrollbar pb-4">
        {/* Header card */}
        <div className="bg-gradient-to-br from-primary-600 to-primary-800 rounded-3xl p-5 text-white mb-5 shadow-xl shadow-primary-600/20">
          <div className="flex items-center gap-3 mb-4">
            <div className="w-12 h-12 rounded-2xl bg-white/20 flex items-center justify-center">
              <Compass size={24} className="text-white" />
            </div>
            <div>
              <h2 className="font-heading font-bold text-base">Jairo da Silva</h2>
              <p className="text-xs text-white/70">Guia Cadastur</p>
            </div>
          </div>
          <div className="bg-white/15 rounded-2xl p-3">
            <div className="flex items-center gap-1.5 mb-1">
              <Clock size={14} className="text-white/70" />
              <span className="text-[10px] font-semibold uppercase text-white/70">Agenda Ativa</span>
            </div>
            <p className="font-bold text-sm">
              Trilha das Samaúmas (09:00) - 8 Ecoturistas
            </p>
          </div>
        </div>

        {/* Primary action */}
        <Button
          variant="accent"
          fullWidth
          size="lg"
          icon={<Plus size={20} />}
          onClick={() => setScreen('trailForm')}
          className="mb-3"
        >
          CADASTRAR NOVA TRILHA / VIVÊNCIA
        </Button>

        <Button
          variant="outline"
          fullWidth
          size="lg"
          icon={<Stamp size={20} />}
          className="mb-5"
        >
          Liberar Selo no Passaporte Verde
        </Button>

        {/* Trails list */}
        <h3 className="font-heading font-bold text-sm text-primary-700 dark:text-white mb-3">
          Trilhas Publicadas
        </h3>
        <div className="space-y-3">
          {data.trails.map((trail) => (
            <div
              key={trail.id}
              className="bg-white dark:bg-surface-dark rounded-2xl p-4 border border-gray-100 dark:border-primary-800"
            >
              <div className="flex items-start gap-3">
                <div className="w-10 h-10 rounded-xl bg-accent-500/15 flex items-center justify-center shrink-0">
                  <Mountain size={20} className="text-accent-500" />
                </div>
                <div className="flex-1">
                  <p className="font-bold text-sm text-primary-700 dark:text-white">{trail.name}</p>
                  <div className="flex items-center gap-3 mt-1.5">
                    <span className={`text-[10px] font-bold px-2 py-0.5 rounded-full ${
                      trail.level === 'Leve' ? 'bg-success-100 text-success-700 dark:bg-success-900/30 dark:text-success-300'
                      : trail.level === 'Moderada' ? 'bg-warning-100 text-warning-700 dark:bg-warning-900/30 dark:text-warning-300'
                      : 'bg-error-100 text-error-700 dark:bg-error-900/30 dark:text-error-300'
                    }`}>
                      {trail.level}
                    </span>
                    <span className="text-xs text-gray-400 dark:text-gray-500 flex items-center gap-1">
                      <Clock size={12} /> {trail.duration}
                    </span>
                    <span className="text-xs text-gray-400 dark:text-gray-500 flex items-center gap-1">
                      <Users size={12} /> {trail.maxPeople}
                    </span>
                  </div>
                  <p className="text-[10px] text-gray-400 dark:text-gray-500 mt-1.5 font-mono">
                    GPS: {trail.gps}
                  </p>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
