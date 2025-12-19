# frozen_string_literal: true

# Versão corrigida do código com tratamento seguro para métodos que podem não existir
# Use respond_to? ou try para verificar se o método existe antes de chamá-lo

processable = process_instance.processable

return false if processable.payments.blank?

processable.payments.find_each do |payment|
  next if payment.items.blank?

  payment.items.find_each do |payment_item|
    data_vencimento = nil

    # Verifica se o método existe antes de chamar
    if payment_item.respond_to?(:net_due_date) && payment_item.net_due_date.present?
      data_vencimento = payment_item.net_due_date.to_date
    elsif payment.respond_to?(:net_due_date) && payment.net_due_date.present?
      data_vencimento = payment.net_due_date.to_date
    elsif processable.respond_to?(:net_due_date) && processable.net_due_date.present?
      data_vencimento = processable.net_due_date.to_date
    end

    # Alternativa usando try (mais conciso, mas pode mascarar erros)
    # data_vencimento = payment_item.try(:net_due_date)&.to_date ||
    #                   payment.try(:net_due_date)&.to_date ||
    #                   processable.try(:net_due_date)&.to_date

    next if data_vencimento.blank?

    data_atual = Time.zone.today
    data_referencia = [data_vencimento, data_atual].max

    dia_referencia = data_referencia.day
    mes_referencia = data_referencia.month
    ano_referencia = data_referencia.year

    if dia_referencia <= 5
      data_calculada = Date.new(ano_referencia, mes_referencia, 6)
    elsif dia_referencia <= 15
      data_calculada = Date.new(ano_referencia, mes_referencia, 16)
    elsif dia_referencia <= 25
      data_calculada = Date.new(ano_referencia, mes_referencia, 26)
    else
      proximo_mes = mes_referencia == 12 ? 1 : mes_referencia + 1
      proximo_ano = mes_referencia == 12 ? ano_referencia + 1 : ano_referencia
      data_calculada = Date.new(proximo_ano, proximo_mes, 6)
    end

    payment_item.cf_prev_pgto = data_calculada
    payment_item.save!(validate: false)
  end
end

return true
