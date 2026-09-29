SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_MarcacaoPonto_Semana_Sel '2017-03-01','2017-03-22','Renata Sousa'
CREATE procedure [dbo].[spATL_MarcacaoPonto_Semana_Sel]
(
	@DataInicial datetime,
	@DataFinal datetime,
	@Responsavel varchar(50)
)

as
print convert(varchar,@DataFinal,103) 
print  convert(varchar,GETDATE(),103)
Declare @UltimaData datetime
set @UltimaData = (select max(convert(datetime,substring(Data,1,2)+ '-'+ substring(Data,3,2) + '-' +substring(Data,5,8),105)) from dbo.Marcacao_Ponto)

if @DataFinal >  @UltimaData
set @DataFinal = @UltimaData
--if  convert(varchar,@DataFinal,103) >=  convert(varchar,GETDATE(),103)
--Begin 
--print 'entrou'
--	set @DataFinal = (select max(convert(datetime,substring(Data,1,2)+ '-'+ substring(Data,3,2) + '-' +substring(Data,5,8),105)) from dbo.Marcacao_Ponto)
--End

Declare @Diferenca int
set @Diferenca = DATEDIFF(day,@DataInicial,@DataFinal) + 1
print @diferenca

Declare @TbHoras1 table(
	Funcionario varchar(100),
	Data date,
	Entrada time,
	Saida_Almoço time,
	Retorno_Almoço time,
	Saida time,
	Horas_Trabalhadas time,
--	Saldo int,
	SaldoP time,
	SaldoN time
)	

Declare @Data date
set @Data = @DataInicial



DECLARE @DIA INT


while  @Diferenca > 0
	Begin
			print @Data
		  SELECT @DIA = (DATEPART(DW,@Data))
		  print @DIA
		if @DIA <> 1
		Begin
		print @Data
		print @DataFinal
		print @Responsavel
			insert @TbHoras1
			exec spATL_MarcacaoPonto_Sel @Data,@DataFinal,@Responsavel
		End
			set @Data =  DateADD(day,1,@Data)
			Set @Diferenca = @Diferenca - 1
		print @Diferenca
	End

select * from @TbHoras1 
order by 1, convert(varchar,Data,103) 
GO
