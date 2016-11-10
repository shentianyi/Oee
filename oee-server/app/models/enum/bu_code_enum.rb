class BuCodeEnum
  MB = 100
  VW = 200
  PSA = 300
  JLR = 400
  GM = 500
  CV = 600
  SI = 700
  CL = 800
  EMO = 900

  def self.display(type)
    case type
      when MB
        'MB'
      when VW
        'VW'
      when PSA
        'PSA'
      when JLR
        'JLR'
      when GM
        'GM'
      when CV
        'CV'
      when SI
        'SI'
      when CL
        'CL'
      when EMO
        'EMO'
    end
  end

  def self.menu
    data = []
    self.constants.each do |c|
      v = self.const_get(c.to_s)
      data << [self.display(v),v]
    end
    data
  end

end