import { useApp } from '../store';
import { AppBar } from '../components/AppBar';
import { Button } from '../components/Button';
import { Ship, Plus, QrCode, Wallet, Navigation, Users } from 'lucide-react';

export function BarqueiroScreen() {
  const { data, setScreen } = useApp();

  const totalToReceive = data.boatTrips.reduce((sum, t) => sum + t.booked * t.pricePerSeat, 0);
  const totalTrips = data.boatTrips.length;

  return (
    <div className="flex flex-col min-h-full bg-[#F8FAF8] dark:bg-primary-900">
      <AppBar title="Painel do Barqueiro" />

      <div className="flex-1 px-5 py-5 overflow-y-auto no-scrollbar pb-4">
        {/* Header card */}
        <div className="bg-gradient-to-br from-secondary-500 to-secondary-700 rounded-3xl p-5 text-white mb-5 shadow-xl shadow-secondary-500/20">
          <div className="flex items-center gap-3 mb-4">
            <div className="w-12 h-12 rounded-2xl bg-white/20 flex items-center justify-center">
              <Ship size={24} className="text-white" />
            </div>
            <div>
              <h2 className="font-heading font-bold text-base">Seu Raimundo Nonato</h2>
              <p className="text-xs text-white/70">Voadeira Rio Negro II</p>
            </div>
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div className="bg-white/15 rounded-2xl p-3">
              <div className="flex items-center gap-1.5 mb-1">
                <Navigation size={14} className="text-white/70" />
                <span className="text-[10px] font-semibold uppercase text-white/70">Saídas Hoje</span>
              </div>
              <p className="font-heading text-2xl font-extrabold">{totalTrips}</p>
            </div>
            <div className="bg-white/15 rounded-2xl p-3">
              <div className="flex items-center gap-1.5 mb-1">
                <Wallet size={14} className="text-white/70" />
                <span className="text-[10px] font-semibold uppercase text-white/70">A Receber</span>
              </div>
              <p className="font-heading text-2xl font-extrabold">R$ {totalToReceive}</p>
            </div>
          </div>
        </div>

        {/* Primary action */}
        <Button
          variant="accent"
          fullWidth
          size="lg"
          icon={<Plus size={20} />}
          onClick={() => setScreen('boatTripForm')}
          className="mb-5"
        >
          CADASTRAR NOVA SAÍDA DE BARCO
        </Button>

        {/* Trips list */}
        <h3 className="font-heading font-bold text-sm text-primary-700 dark:text-white mb-3">
          Saídas Programadas
        </h3>
        <div className="space-y-3">
          {data.boatTrips.map((trip) => {
            const pct = (trip.booked / trip.maxCapacity) * 100;
            return (
              <div
                key={trip.id}
                className="bg-white dark:bg-surface-dark rounded-2xl p-4 border border-gray-100 dark:border-primary-800"
              >
                <div className="flex items-start justify-between mb-3">
                  <div>
                    <p className="font-bold text-sm text-primary-700 dark:text-white">{trip.route}</p>
                    <p className="text-xs text-gray-400 dark:text-gray-500 mt-0.5">
                      {trip.boat} • Partida {trip.departure}
                    </p>
                  </div>
                  <span className="font-heading font-extrabold text-sm text-accent-600 dark:text-accent-300">
                    R$ {trip.pricePerSeat}
                  </span>
                </div>

                {/* Capacity bar */}
                <div className="mb-3">
                  <div className="flex items-center justify-between mb-1.5">
                    <div className="flex items-center gap-1.5">
                      <Users size={14} className="text-gray-400" />
                      <span className="text-xs font-semibold text-gray-500 dark:text-gray-400">
                        {trip.booked}/{trip.maxCapacity} vagas
                      </span>
                    </div>
                    <span className="text-[10px] font-bold text-gray-400 dark:text-gray-500">
                      {pct.toFixed(0)}% ocupado
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

                <Button variant="outline" size="sm" fullWidth icon={<QrCode size={16} />}>
                  Validar Voucher (QR Code)
                </Button>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}
