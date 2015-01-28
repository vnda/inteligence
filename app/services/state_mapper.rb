class StateMapper

  STATES = {
    'AC'=>'Acre',
    'AL'=>'Alagoas',
    'AP'=>'Amapá',
    'AM'=>'Amazonas',
    'BA'=>'Bahia',
    'CE'=>'Ceará',
    'DF'=>'Distrito Federal',
    'ES'=>'Espírito Santo',
    'GO'=>'Goiás',
    'MA'=>'Maranhão',
    'MT'=>'Mato Grosso',
    'MS'=>'Mato Grosso do Sul',
    'MG'=>'Minas Gerais',
    'PA'=>'Pará',
    'PB'=>'Paraíba',
    'PR'=>'Paraná',
    'PE'=>'Pernambuco',
    'PI'=>'Piauí',
    'RJ'=>'Rio de Janeiro',
    'RN'=>'Rio Grande do Norte',
    'RS'=>'Rio Grande do Sul',
    'RO'=>'Rondônia',
    'RR'=>'Roraima',
    'SC'=>'Santa Catarina',
    'SP'=>'São Paulo',
    'SE'=>'Sergipe',
    'TO'=>'Tocantins',
    'Amapa' => 'Amapá',
    'Ceara' => 'Ceará',
    'Espirito Santo' => 'Espírito Santo',
    'Federal District' => 'Distrito Federal',
    'State of Goias' => 'Goiás',
    'Maranhao' => 'Maranhão',
    'Para' => 'Pará',
    'Paraiba' => 'Paraíba',
    'Parana' => 'Paraná',
    'Piaui' => 'Piauí',
    'Rondonia' => 'Rondônia',
    'Sao Paulo' => 'São Paulo'
    }.freeze

  def self.state_for(state)
    state.slice!('State of ')
    STATES[state] || state
  end
end