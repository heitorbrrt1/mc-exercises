function main()
    clear; clc; close all;

    % Definição da função
    f = @(x) tan(x) .* (17.5*x.^3 - 44*x.^2 + 887*x + 229);

    % Parâmetros do método
    a = 3.0;
    b = 4.0;

    % Tolerância e máximo de iterações
    tol = 1e-5;
    max_iter = 1000;

    % Cabeçalho
    fprintf('Método da Falsa Posição\n');
    fprintf('Função: f(x) = 16*x*sin(x/10) - 37/2\n');
    fprintf('Intervalo: [%.1f, %.1f] | Tolerância: %.0e\n\n', a, b, tol);

    % Execução do método numérico
    [raiz, historico, num_iter] = metodo_falsa_posicao(f, a, b, tol, max_iter);

    % Impressão dos resultados no terminal
    imprimir_resultados(raiz, historico, num_iter, f);

    % Plotagem do gráfico animado
    plotar_animacao(f, a, b, historico);

    % Plotagem do gráfico de convergência
    plotar_convergencia(historico, num_iter);
end

%% Função do Método Numérico
function [raiz, historico, num_iter] = metodo_falsa_posicao(f, a, b, tol, max_iter)
    % Inicialização
    fa = f(a);
    fb = f(b);

    % Verificar mudança de sinal
    if fa * fb > 0
        error('A função não muda de sinal no intervalo [a,b]');
    end

    % Pré-alocação de memória para histórico
    historico.x = zeros(max_iter, 1);
    historico.fx = zeros(max_iter, 1);
    historico.erro = zeros(max_iter, 1);

    x_old = a;

    % Loop principal do método
    for iter = 1:max_iter
        x = (a*fb - b*fa) / (fb - fa);
        fx = f(x);

        if iter > 1
            erro = abs((x - x_old) / x);
        else
            erro = inf;
        end

        % Armazenar histórico
        historico.x(iter) = x;
        historico.fx(iter) = fx;
        historico.erro(iter) = erro;

        % Verificação de convergência
        if erro < tol && iter > 1
            num_iter = iter;
            historico.x = historico.x(1:iter);
            historico.fx = historico.fx(1:iter);
            historico.erro = historico.erro(1:iter);
            raiz = x;
            return;
        end

        % Atualização dos limites baseado no sinal
        if fa * fx < 0
            b = x;
            fb = fx;
        else
            a = x;
            fa = fx;
        end

        x_old = x;
    end

    num_iter = max_iter;
    raiz = x;
    warning('Número máximo de iterações atingido');
end

%% Função de imprimir os resultados
function imprimir_resultados(raiz, historico, num_iter, f)
    fprintf('\n========================================\n');
    fprintf('  RESULTADOS FINAIS\n');
    fprintf('========================================\n');
    fprintf('Raiz encontrada: x = %.6f\n', raiz);
    fprintf('f(x) = %.10e\n', f(raiz));
    fprintf('Número de iterações: %d\n', num_iter);
    fprintf('========================================\n\n');

    fprintf('Histórico de x (todosX):\n');

    % Cria o vetor com o nome que você quer
    todosX = historico.x;

    for k = 1:num_iter
        fprintf('Iteração %2d: x = %.6f\n', k, todosX(k));
    end
    % ----------------------------------------
end

%% Função de plotagem - Animação
function plotar_animacao(f, a, b, historico)
    figure('Name', 'Animação do Método da Falsa Posição', ...
           'Position', [100 100 900 600]);

    % Preparação dos dados
    xx = linspace(a, b, 1000);
    yy = f(xx);
    num_iter = length(historico.x);

    for i = 1:num_iter
        clf;

        % Plot da função f(x)
        plot(xx, yy, 'b-', 'LineWidth', 2); hold on;

        % Plot da linha y = 0
        plot([a b], [0 0], 'k--', 'LineWidth', 1);

        % Plot do ponto atual (destaque)
        plot(historico.x(i), historico.fx(i), 'ro', ...
             'MarkerSize', 12, 'MarkerFaceColor', 'r', 'LineWidth', 2);

        grid on;
        xlabel('x', 'FontSize', 12);
        ylabel('f(x)', 'FontSize', 12);
        title(sprintf('Iteração %d/%d | x = %.6f | f(x) = %.4e', ...
              i, num_iter, historico.x(i), historico.fx(i)), 'FontSize', 14);
        legend('f(x)', 'y = 0', 'Ponto atual', 'Location', 'northeast');
        ylim([min(yy)*1.1 max(yy)*1.1]);

        hold off;
        pause(0.5);
    end

    % Frame final destacando a raiz
    plot(xx, yy, 'b-', 'LineWidth', 2); hold on;
    plot([a b], [0 0], 'k--', 'LineWidth', 1);
    plot(historico.x(end), historico.fx(end), 'ro', ...
         'MarkerSize', 15, 'MarkerFaceColor', 'r', 'LineWidth', 2);
    grid on;
    xlabel('x', 'FontSize', 12);
    ylabel('f(x)', 'FontSize', 12);
    title(sprintf('CONVERGÊNCIA! Raiz: x = %.6f (em %d iterações)', ...
          historico.x(end), num_iter), 'FontSize', 14, 'FontWeight', 'bold');
    legend('f(x)', 'y = 0', sprintf('Raiz: x = %.6f', historico.x(end)), ...
           'Location', 'northeast');
    ylim([min(yy)*1.1 max(yy)*1.1]);
    hold off;
end

%% Função de plotagem
%% Função de plotagem - Convergência (APENAS CÍRCULOS)
function plotar_convergencia(historico, num_iter)
    figure('Name', 'Análise de Convergência', ...
           'Position', [150 150 1000 700]);

    % Evolução da aproximação - Já era círculo (b-o)
    subplot(2, 2, 1);
    plot(1:num_iter, historico.x, 'b-o', 'LineWidth', 1.5, 'MarkerSize', 6);
    grid on;
    xlabel('Iteração', 'FontSize', 11);
    ylabel('x', 'FontSize', 11);
    title('Evolução da Aproximação x', 'FontSize', 12, 'FontWeight', 'bold');

    % Erro relativo - Mudado de 'r-s' (quadrado) para 'r-o' (círculo)
    subplot(2, 2, 2);
    semilogy(2:num_iter, historico.erro(2:end), 'r-o', 'LineWidth', 1.5, 'MarkerSize', 6);
    grid on;
    xlabel('Iteração', 'FontSize', 11);
    ylabel('Erro Relativo (log)', 'FontSize', 11);
    title('Erro Relativo vs Iteração', 'FontSize', 12, 'FontWeight', 'bold');

    % Valor da função f(x) - Mudado de 'm-d' (diamante) para 'm-o' (círculo)
    subplot(2, 2, 3);
    semilogy(1:num_iter, abs(historico.fx), 'm-o', 'LineWidth', 1.5, 'MarkerSize', 6);
    grid on;
    xlabel('Iteração', 'FontSize', 11);
    ylabel('|f(x)| (log)', 'FontSize', 11);
    title('Valor Absoluto de f(x)', 'FontSize', 12, 'FontWeight', 'bold');

    %sgtitle('Análise de Convergência - Método da Falsa Posição', ...
    %        'FontSize', 14, 'FontWeight', 'bold');
end

main();
