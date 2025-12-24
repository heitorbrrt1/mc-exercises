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
    fprintf('Método da Bisseção\n');
    fprintf('Função: f(x) = x^3 + 2*x^2 - 2\n');
    fprintf('Intervalo: [%.1f, %.1f] | Tolerância: %.0e\n\n', a, b, tol);

    % Execução do método numérico
    [raiz, historico, num_iter] = metodo_bisseccao(f, a, b, tol, max_iter);

    % Impressão dos resultados no terminal
    imprimir_resultados(raiz, historico, num_iter, f);

    % Plotagem do gráfico animado
    plotar_animacao(f, a, b, historico);

    % Plotagem do gráfico de convergência
    plotar_convergencia(historico, num_iter);
end

%% Função do Método Numérico
function [raiz, historico, num_iter] = metodo_bisseccao(f, a, b, tol, max_iter)
    % Inicialização
    fa = f(a);
    fb = f(b);

    % Verificar mudança de sinal
    if fa * fb > 0
        error('A função não muda de sinal no intervalo [a,b]');
    end

    % Pré-alocação de memória para histórico
    historico.a = zeros(max_iter, 1);
    historico.b = zeros(max_iter, 1);
    historico.x = zeros(max_iter, 1);
    historico.fx = zeros(max_iter, 1);
    historico.erro = zeros(max_iter, 1);

    % Loop principal do método
    for iter = 1:max_iter
        % Ponto médio do intervalo (característica da bisseção)
        x = (a + b) / 2;
        fx = f(x);

        % Cálculo do erro relativo
        if iter > 1
            erro = abs((x - historico.x(iter-1)) / x);
        else
            erro = inf;
        end

        % Armazenar histórico
        historico.a(iter) = a;
        historico.b(iter) = b;
        historico.x(iter) = x;
        historico.fx(iter) = fx;
        historico.erro(iter) = erro;

        % Verificação de convergência
        if erro < tol && iter > 1
            num_iter = iter;
            historico.a = historico.a(1:iter);
            historico.b = historico.b(1:iter);
            historico.x = historico.x(1:iter);
            historico.fx = historico.fx(1:iter);
            historico.erro = historico.erro(1:iter);
            raiz = x;
            return;
        end

        % Atualização dos limites baseado no sinal (sempre divide ao meio)
        if fa * fx < 0
            b = x;
            fb = fx;
        else
            a = x;
            fa = fx;
        end
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
%% Função de plotagem - Animação (LIMPA)
function plotar_animacao(f, a, b, historico)
    figure('Name', 'Animação do Método da Bisseção', ...
           'Position', [100 100 900 600]);

    % Preparação dos dados
    a_orig = historico.a(1);
    b_orig = historico.b(1);
    xx = linspace(a_orig, b_orig, 1000);
    yy = f(xx);
    num_iter = length(historico.x);

    for i = 1:num_iter
        clf;

        % Plot da função f(x) (Linha Azul)
        plot(xx, yy, 'b-', 'LineWidth', 2); hold on;

        % Plot da linha y = 0 (Tracejado Preto)
        plot([a_orig b_orig], [0 0], 'k--', 'LineWidth', 1);

        % Plot do ponto médio/Raiz atual (Bolinha Vermelha)
        plot(historico.x(i), historico.fx(i), 'ro', ...
             'MarkerSize', 12, 'MarkerFaceColor', 'r', 'LineWidth', 2);

        grid on;
        xlabel('x', 'FontSize', 12);
        ylabel('f(x)', 'FontSize', 12);
        title(sprintf('Iteração %d/%d | x = %.6f | f(x) = %.4e', ...
              i, num_iter, historico.x(i), historico.fx(i)), ...
              'FontSize', 13);

        % Legenda limpa
        legend('f(x)', 'y = 0', 'Raiz Aproximada', 'Location', 'northeast');
        ylim([min(yy)*1.1 max(yy)*1.1]);

        hold off;
        pause(0.5); % Tempo da animação
    end

    % Frame final destacando a raiz
    plot(xx, yy, 'b-', 'LineWidth', 2); hold on;
    plot([a_orig b_orig], [0 0], 'k--', 'LineWidth', 1);
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

%% Função de plotagem - Convergência
function plotar_convergencia(historico, num_iter)
    figure('Name', 'Análise de Convergência', ...
           'Position', [150 150 1000 700]);

    % Evolução da aproximação
    subplot(2, 2, 1);
    plot(1:num_iter, historico.x, 'b-o', 'LineWidth', 1.5, 'MarkerSize', 6);
    grid on;
    xlabel('Iteração', 'FontSize', 11);
    ylabel('x', 'FontSize', 11);
    title('Evolução da Aproximação x', 'FontSize', 12, 'FontWeight', 'bold');

    % Erro relativo (escala logarítmica) - Círculos Vermelhos
    subplot(2, 2, 2);
    semilogy(2:num_iter, historico.erro(2:end), 'r-o', 'LineWidth', 1.5, 'MarkerSize', 6);
    grid on;
    xlabel('Iteração', 'FontSize', 11);
    ylabel('Erro Relativo (log)', 'FontSize', 11);
    title('Erro Relativo vs Iteração', 'FontSize', 12, 'FontWeight', 'bold');

    % Valor da função f(x) - Círculos Magenta
    subplot(2, 2, 3);
    semilogy(1:num_iter, abs(historico.fx), 'm-o', 'LineWidth', 1.5, 'MarkerSize', 6);
    grid on;
    xlabel('Iteração', 'FontSize', 11);
    ylabel('|f(x)| (log)', 'FontSize', 11);
    title('Valor Absoluto de f(x)', 'FontSize', 12, 'FontWeight', 'bold');

    % Redução do intervalo - Círculos Verdes
    subplot(2, 2, 4);
    intervalo = historico.b - historico.a;
    semilogy(1:num_iter, intervalo, 'g-o', 'LineWidth', 1.5, 'MarkerSize', 6);
    grid on;
    xlabel('Iteração', 'FontSize', 11);
    ylabel('Tamanho do Intervalo (log)', 'FontSize', 11);
    title('Redução do Intervalo [a, b]', 'FontSize', 12, 'FontWeight', 'bold');

    %sgtitle('Análise de Convergência - Método da Bisseção', ...
    %        'FontSize', 14, 'FontWeight', 'bold');
end

main();
