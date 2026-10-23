import { useApp } from '../store';
import { AppBar } from '../components/AppBar';
import { QRCode } from '../components/QRCode';
import { Button } from '../components/Button';
import { WifiOff, Calendar, Clock, Ship, Users, Ticket } from 'lucide-react';

export function VoucherScreen() {
  const { data, setScreen } = useApp();
  const voucher = data.vouchers[data.vouchers.length - 1];

  return (
    <div className="flex flex-col min-h-full bg-[#F8FAF8] dark:bg-primary-900">
      <AppBar
        title="Meu Voucher"
        showBack
        onBack={() => setScreen('catalog')}
      />

      <div className="flex-1 px-5 py-5 overflow-y-auto no-scrollbar">
        {/* Offline banner */}
        <div className="bg-warning-50 dark:bg-warning-900/20 rounded-2xl p-3 flex items-center gap-2.5 mb-5">
          <WifiOff size={18} className="text-warning-600 dark:text-warning-400 shrink-0" />
          <p className="text-xs text-warning-700 dark:text-warning-300 font-medium leading-relaxed">
            MODO OFFLINE ATIVO: Este voucher está salvo no seu aparelho e é 100% legível sem sinal de internet.
          </p>
        </div>

        {voucher ? (
          <div className="bg-white dark:bg-surface-dark rounded-3xl overflow-hidden shadow-lg border border-gray-100 dark:border-primary-800 animate-scale-in">
            {/* Ticket header */}
            <div className="bg-primary-600 px-5 py-4 text-white flex items-center gap-3">
              <Ticket size={24} className="text-accent-300" />
              <div>
                <p className="font-heading font-bold text-sm">BANZEIRO TOUR PASS</p>
                <p className="text-xs text-white/60 font-semibold">#{voucher.code}</p>
              </div>
            </div>

            {/* Ticket body */}
            <div className="px-5 py-5">
              <h3 className="font-heading font-bold text-sm text-primary-700 dark:text-white mb-4">
                {voucher.experienceTitle}
              </h3>

              <div className="space-y-3 mb-5">
                <div className="flex items-center gap-3">
                  <Calendar size={18} className="text-accent-500 shrink-0" />
                  <div>
                    <p className="text-[10px] text-gray-400 dark:text-gray-500 font-semibold uppercase">Data</p>
                    <p className="text-sm font-bold text-primary-700 dark:text-white">{voucher.date}</p>
                  </div>
                </div>
                <div className="flex items-center gap-3">
                  <Clock size={18} className="text-accent-500 shrink-0" />
                  <div>
                    <p className="text-[10px] text-gray-400 dark:text-gray-500 font-semibold uppercase">Horário</p>
                    <p className="text-sm font-bold text-primary-700 dark:text-white">{voucher.time}</p>
                  </div>
                </div>
                <div className="flex items-center gap-3">
                  <Ship size={18} className="text-accent-500 shrink-0" />
                  <div>
                    <p className="text-[10px] text-gray-400 dark:text-gray-500 font-semibold uppercase">Embarcação</p>
                    <p className="text-sm font-bold text-primary-700 dark:text-white">{voucher.boat}</p>
                  </div>
                </div>
                <div className="flex items-center gap-3">
                  <Users size={18} className="text-accent-500 shrink-0" />
                  <div>
                    <p className="text-[10px] text-gray-400 dark:text-gray-500 font-semibold uppercase">Passageiros</p>
                    <p className="text-sm font-bold text-primary-700 dark:text-white">{voucher.passengers}</p>
                  </div>
                </div>
              </div>

              {/* Dashed divider */}
              <div className="flex items-center gap-2 mb-5">
                <div className="w-4 h-4 rounded-full bg-[#F8FAF8] dark:bg-primary-900 -ml-5 border border-gray-200 dark:border-primary-700" />
                <div className="flex-1 border-t-2 border-dashed border-gray-200 dark:border-primary-700" />
                <div className="w-4 h-4 rounded-full bg-[#F8FAF8] dark:bg-primary-900 -mr-5 border border-gray-200 dark:border-primary-700" />
              </div>

              {/* QR Code */}
              <div className="flex flex-col items-center">
                <div className="p-3 bg-white rounded-2xl border-2 border-gray-100 dark:border-primary-800">
                  <QRCode value={voucher.uuid} size={180} />
                </div>
                <p className="text-[10px] text-gray-400 dark:text-gray-500 font-mono mt-3 break-all text-center px-4">
                  {voucher.uuid}
                </p>
              </div>
            </div>
          </div>
        ) : (
          <div className="flex flex-col items-center justify-center py-20 text-center">
            <Ticket size={48} className="text-gray-300 dark:text-gray-600 mb-4" />
            <p className="text-sm font-bold text-gray-500 dark:text-gray-400 mb-1">
              Nenhum voucher ainda
            </p>
            <p className="text-xs text-gray-400 dark:text-gray-500 mb-5">
              Agende uma experiência para gerar seu voucher offline
            </p>
            <Button variant="accent" onClick={() => setScreen('catalog')}>
              Explorar Experiências
            </Button>
          </div>
        )}
      </div>
    </div>
  );
}
