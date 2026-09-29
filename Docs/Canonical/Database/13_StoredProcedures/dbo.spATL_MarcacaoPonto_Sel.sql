SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_MarcacaoPonto_Sel '2016-03-10','2016-03-10','Anderson Oliveira'
CREATE procedure [dbo].[spATL_MarcacaoPonto_Sel]
(
	@DataInicial datetime,
	@DataFinal datetime,
	@Responsavel varchar(50)
)

as
Declare @DATA datetime
DECLARE @DIA INT
  SELECT @DIA = (DATEPART(DW,@DataInicial))
  print @dia
if @DIA in (1)
	set @DataInicial = @DataInicial -2




Declare @TbTemp Table(
	Funcionario varchar(50),
	Entrada	datetime,
	AlmocoS datetime,
	AlmocoR datetime,
	Saida datetime
)


Declare @TbGeral Table(
	Funcionario varchar(50),
	Data datetime
	)
Declare @TbGeral1 Table(
	ID int,
	Funcionario varchar(50),
	Data datetime
	)
	
if exists(select ID from Marcacao_Ponto MP where convert(datetime,substring(MP.Data,1,2)+ '-'+ substring(MP.Data,3,2) + '-' +substring(MP.Data,5,8),105) between @DataInicial and @DataFinal)
	Begin
			
		insert @TbGeral
		select Nome_Funcionario Funcionario, convert(datetime,substring(MP.Data,1,2)+ '-'+ substring(MP.Data,3,2) + '-' +substring(MP.Data,5,8) + ' ' + substring(MP.Hora,1,2) + ':' + substring(MP.Hora,3,2),105) Data from Marcacao_Ponto MP
		join RH_Ponto RH on MP.PIS = '0'+RH.PIS
		join Usuario US on RH.Responsavel = US.Cd_Usuario
		where convert(datetime,substring(MP.Data,1,2)+ '-'+ substring(MP.Data,3,2) + '-' +substring(MP.Data,5,8),105) = @DataInicial and US.Nome_Usuario = @Responsavel
		

		insert into @TbTemp
		select Funcionario,NULL,NULL,NULL,NULL from @TbGeral group by Funcionario
		--select * from @TbGeral
		declare @Funcionario varchar(50)
		Declare C_Funcionario cursor for
		select Funcionario from @TbTemp
		Open C_Funcionario
		SET NOCOUNT ON
		Fetch Next From C_Funcionario Into @Funcionario

				While @@FETCH_STATUS = 0
					Begin
						INSERT @TbGeral1
						select ROW_NUMBER() OVER(ORDER BY Funcionario DESC) AS Row,* from @TbGeral where Funcionario = @Funcionario order by Funcionario, Data
						--print @Funcionario
						--select * from @TbTemp
						update @TbTemp set Entrada = Data from @TbTemp TP INNER join @TbGeral1 GR on TP.Funcionario = GR.Funcionario AND gr.ID = 1  
						--select * from @TbTemp
						update @TbTemp set AlmocoS = Data from @TbTemp TP INNER join @TbGeral1 GR on TP.Funcionario = GR.Funcionario AND gr.ID = 2
						--select * from @TbTemp
						update @TbTemp set AlmocoR = Data from @TbTemp TP INNER join @TbGeral1 GR on TP.Funcionario = GR.Funcionario AND gr.ID = 3  
						--select * from @TbTemp
						update @TbTemp set SAIDA = Data from @TbTemp TP INNER join @TbGeral1 GR on TP.Funcionario = GR.Funcionario AND gr.ID = 4
						
						Fetch Next From C_Funcionario Into @Funcionario
				End
		close C_Funcionario
		deallocate C_Funcionario 

		Declare @TbHoras table(
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
		insert @TbHoras
		select Funcionario,CONVERT(date,entrada,105)[Data],CONVERT(time,isnull(entrada,0))[Entrada],CONVERT(time,isnull(AlmocoS,0))[Saida Almoço],CONVERT(time,isnull(AlmocoR,0))[Retorno Almoço],CONVERT(time,isnull(saida,0))[Saida], CONVERT(time,(isnull(saida,0) - isnull(entrada,0)) -(isnull(AlmocoR,0)-isnull(AlmocoS,0)))[Horas Trabalhadas],Null,null from @TbTemp
		--where  not CONVERT(time,(isnull(saida,0) - isnull(entrada,0)) -(isnull(AlmocoR,0)-isnull(AlmocoS,0)))between CONVERT(time,'00:00:00') and CONVERT(time,'00:00:00')

		--update @TbHoras set Saldo = 
		--DATEPART(hh,convert(datetime,Horas_Trabalhadas) - convert(datetime,'08:30:00'))*60 + 
		--DATEPART(n,convert(datetime,Horas_Trabalhadas) - convert(datetime,'08:30:00')) 
		--where Horas_Trabalhadas >= CONVERT(time,'08:40:00')

		--update @TbHoras set Saldo = 
		--((DATEPART(n,CONVERT(datetime,'23:59:00') - (convert(datetime,Horas_Trabalhadas) - convert(datetime,'08:30:00'))) +1)
		--+
		--(DATEPART(hh,CONVERT(datetime,'23:59:00') - (convert(datetime,Horas_Trabalhadas) - convert(datetime,'08:30:00')))) *60) *-1
		--where Horas_Trabalhadas < CONVERT(time,'08:20:00') 

		update @TbHoras set SaldoP = 
		(convert(datetime,Horas_Trabalhadas) - convert(datetime,'08:30:00'))
		where Horas_Trabalhadas >= CONVERT(time,'08:40:00')

		update @TbHoras set SaldoN = 
		CONVERT(datetime,'23:59:00') - (convert(datetime,Horas_Trabalhadas) - convert(datetime,'08:31:00'))
		where Horas_Trabalhadas < CONVERT(time,'08:20:00') 

		select 	Funcionario,
			Data,
			Entrada,
			Saida_Almoço [Saida Almoço],
			Retorno_Almoço [Retorno Almoço],
			Saida,
			Horas_Trabalhadas [Horas Trabalhadas],
			SaldoP [Saldo(+)],
			SaldoN [Saldo(-)]
		from @TbHoras
End
else
select 'Arquivo não disponivel para leitura. Por favor, entrar em contato com o departamento de RH.' [Mensagem]


GO
