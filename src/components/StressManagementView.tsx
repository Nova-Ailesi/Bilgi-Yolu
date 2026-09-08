import React, { useState, useEffect } from 'react';
import { ArrowLeft, Play, Square, Sparkles, Heart, Brain, Clock } from 'lucide-react';

interface StressManagementViewProps {
  onBack: () => void;
}

export const StressManagementView: React.FC<StressManagementViewProps> = ({ onBack }) => {
  const [isRunning, setIsRunning] = useState(false);
  const [phase, setPhase] = useState<'Nefes Al' | 'Nefesini Tut' | 'Yavaşça Ver' | 'Hazır mısın?'>('Hazır mısın?');
  const [secondsLeft, setSecondsLeft] = useState(4);
  const [completedCycles, setCompletedCycles] = useState(0);

  useEffect(() => {
    let timer: NodeJS.Timeout;

    if (isRunning) {
      timer = setInterval(() => {
        setSecondsLeft((prev) => {
          if (prev <= 1) {
            // Aşama geçişi
            if (phase === 'Nefes Al') {
              setPhase('Nefesini Tut');
              return 7;
            } else if (phase === 'Nefesini Tut') {
              setPhase('Yavaşça Ver');
              return 8;
            } else {
              // Döngü tamamlandı
              setCompletedCycles((c) => c + 1);
              setPhase('Nefes Al');
              return 4;
            }
          }
          return prev - 1;
        });
      }, 1000);
    }

    return () => clearInterval(timer);
  }, [isRunning, phase]);

  const handleStart = () => {
    setIsRunning(true);
    setPhase('Nefes Al');
    setSecondsLeft(4);
  };

  const handleStop = () => {
    setIsRunning(false);
    setPhase('Hazır mısın?');
    setSecondsLeft(4);
  };

  return (
    <div className="p-4 sm:p-5 max-w-xl mx-auto space-y-6 text-center">
      <div className="flex items-center justify-between">
        <button
          onClick={onBack}
          className="flex items-center gap-1.5 text-xs text-slate-400 hover:text-white p-1 rounded-lg transition-colors cursor-pointer"
        >
          <ArrowLeft className="w-4 h-4" />
          <span>Geri</span>
        </button>
        <h3 className="font-bold text-sm text-white">Sınav Kaygısı & Stres Yönetimi</h3>
        <div className="w-12" />
      </div>

      <div className="space-y-1">
        <h2 className="text-xl font-bold text-white flex items-center justify-center gap-2">
          <Brain className="w-5 h-5 text-blue-400" />
          4-7-8 Bilimsel Nefes Egzersizi
        </h2>
        <p className="text-xs text-slate-400 max-w-sm mx-auto">
          Kalp ritmini sakinleştirir, otonom sinir sistemini dengeler ve sınav öncesi odaklanmayı zirveye taşır.
        </p>
      </div>

      {/* Animasyonlu Ritmik Nefes Çemberi */}
      <div className="py-6 flex items-center justify-center">
        <div className="relative flex items-center justify-center">
          {/* Dış Halka Pulseları */}
          <div
            className={`absolute w-64 h-64 rounded-full transition-all duration-1000 ${
              phase === 'Nefes Al'
                ? 'scale-110 bg-blue-500/20'
                : phase === 'Nefesini Tut'
                ? 'scale-110 bg-amber-500/20'
                : 'scale-90 bg-emerald-500/20'
            }`}
          />

          {/* Ana Nefes Küresi */}
          <div
            className={`w-52 h-52 rounded-full flex flex-col items-center justify-center text-white shadow-2xl transition-all border-4 ${
              phase === 'Nefes Al'
                ? 'scale-105 bg-gradient-to-tr from-blue-700 to-indigo-500 border-blue-300 shadow-blue-500/40 duration-[4000ms]'
                : phase === 'Nefesini Tut'
                ? 'scale-105 bg-gradient-to-tr from-amber-600 to-yellow-500 border-amber-300 shadow-amber-500/40 duration-[7000ms]'
                : phase === 'Yavaşça Ver'
                ? 'scale-90 bg-gradient-to-tr from-emerald-700 to-teal-500 border-emerald-300 shadow-emerald-500/40 duration-[8000ms]'
                : 'scale-95 bg-slate-800 border-slate-700'
            }`}
          >
            <span className="text-xl font-bold">{phase}</span>
            {isRunning && (
              <span className="text-4xl font-black font-mono mt-1">{secondsLeft}s</span>
            )}
          </div>
        </div>
      </div>

      <div className="text-xs text-slate-300 font-medium">
        Tamamlanan Döngü: <span className="font-bold text-amber-400">{completedCycles}</span>
      </div>

      {/* Kontrol Butonları */}
      <div className="flex justify-center">
        {!isRunning ? (
          <button
            onClick={handleStart}
            className="bg-[#002366] hover:bg-blue-800 text-white font-bold py-3.5 px-8 rounded-2xl flex items-center gap-2 shadow-lg shadow-blue-950 transition-all cursor-pointer text-sm"
          >
            <Play className="w-4 h-4 fill-white" />
            Egzersize Başla
          </button>
        ) : (
          <button
            onClick={handleStop}
            className="bg-red-600 hover:bg-red-500 text-white font-bold py-3.5 px-8 rounded-2xl flex items-center gap-2 shadow-lg transition-all cursor-pointer text-sm"
          >
            <Square className="w-4 h-4 fill-white" />
            Durdur
          </button>
        )}
      </div>

      {/* Sınav Kaygısı İpuçları */}
      <div className="bg-slate-900 border border-slate-800 rounded-xl p-4 text-left text-xs space-y-2 text-slate-300">
        <div className="font-bold text-white flex items-center gap-1.5">
          <Sparkles className="w-4 h-4 text-amber-400" />
          Sınav Kaygısını Yenmek İçin 3 Altın Kural:
        </div>
        <p>1. <strong>Soruları kişiselleştirmeyin:</strong> Bir soruda takıldığınızda vakit kaybetmeden yanına işaret koyup geçin (Turlama Tekniği).</p>
        <p>2. <strong>Fiziksel duruş:</strong> Sırtınızı dik tutun ve 3 kez derin nefes alıp omuzlarınızı gevşetin.</p>
        <p>3. <strong>İç diyalog:</strong> "Elimden gelenin en iyisini yapıyorum, her soru yeni bir fırsat" telkinini hatırlayın.</p>
      </div>
    </div>
  );
};
