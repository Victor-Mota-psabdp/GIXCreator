SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spATLNetRevenueIM_Sel] --'W','D','','DOLAR AMERICANO'
			@Parametro	Char(1),
			@Tipo		Char(1),
			@Agente		Varchar(40),
			@Moeda		Varchar(50)

AS

Declare		@DataInicial	Datetime
Declare		@DataFinal		Datetime
Declare		@MoedaDestino	Varchar(3)
Declare		@Mes			Int
Declare		@Ano			Int
Declare		@IntI			Int
Declare		@DataTemp		Datetime

SEt @MoedaDestino=(select cd_tp_moeda from tipo_moeda where nome_Tp_moeda=@Moeda)
SET Nocount on;
Declare @Resultado Table
		(	
			Processo Varchar(16),
			Agente	Varchar(40),
			Date	Datetime,
			Moeda	Char(3),
			Valor	float
		)
Declare @Colunas Table
	(
		IDMes	Int,
		MesAno	Datetime
	)

if @Parametro='M'
		Begin
--			Set @mes=(month(getdate())-11)*-1
--			if month(getdate())<12 
--				begin
--					set @Ano=year(Getdate())-1
--				End
--			Set @DataInicial=cast(@ano as varchar(4)) +'-' + right('0' + cast(@mes as varchar(4)),2)  +  '-01'

			set @DataTemp = (select dateadd(month,-11,getdate()))

			Set @DataInicial=cast(year(@DataTemp) as varchar(4)) + '-' + right('0' + cast(month(@DataTemp) as varchar(2)),2)  +  '-01'

			Set @Datafinal=getdate()

			set @IntI=1

			Insert @Colunas values(1,@datainicial)

			While @IntI <=11
				Begin
					set @inti=@inti+1
					Set @DataTemp=(select max(mesano) from @Colunas) + 31
					Set @Mes=month(@dataTemp)
					SEt @Ano=year(@DataTemp)
					Set @DataTemp=cast(@ano as varchar(4)) +'-' + right('0' + cast(@mes as varchar(2)),2)  +  '-01'
					Insert @Colunas values(@inti,@DataTemp)	
				End
			if @Tipo='C' 
				Begin
					Select  cast(month(MesAno) as Varchar(2)) + '/' + cast(year(mesano) as varchar(4)) Colunas  from @Colunas

				End
			Else
				begin
					insert @Resultado

					select 
						hou.num_proc_him,Nome_Raz_Soc,eta_master ETA_Master,cta.cd_tp_moeda,sum(dbo.Valor(vlr_org_hia,cta.dc_hia))
					from 
						House_imp_mar HOU with(nolock)
						Join Master_Imp_mar MAS with(nolock) on mas.num_proc_mim=hou.num_proc_mim and hou.num_proc_mim <> 'JOB'
						Join LLP_Master LLP  with(nolock) on LLP.num_proc_master=mas.num_proc_mim
						Join Pessoa PP on pp.cd_pes=cd_export_mim
						Join vwcta_Cte CTA on CTa.num_proc_hia=hou.num_proc_him
						LEft Join Vwcxas CXA on CTA.num_proc_hia=cxa.num_proc_hia and CTA.cd_tp_Tx=cxa.cd_tp_Tx and CTA.dc_hia=cxa.dc_hia
					where
						ETA_Master between @DataInicial and @DataFinal And
						(apelido like @agente or @agente='')
						and cxa.Num_LCto is null
						and desp_org_hia='N'
					Group by hou.num_proc_him,Nome_Raz_Soc,eta_master ,cta.cd_tp_moeda



					Union all


					select 
						hou.num_proc_him,Nome_Raz_Soc,eta_master ETA_Master,'REL',sum(dbo.Valor(Vlr_Pgto_Rcto_Hia,cta.dc_hia))
					from 
						House_imp_mar HOU with(nolock)
						Join Master_Imp_mar MAS with(nolock) on mas.num_proc_mim=hou.num_proc_mim and hou.num_proc_mim <> 'JOB'
						Join LLP_Master LLP  with(nolock) on LLP.num_proc_master=mas.num_proc_mim
						Join Pessoa PP on pp.cd_pes=cd_export_mim
						Join vwcta_Cte CTA on CTa.num_proc_hia=hou.num_proc_him
						Join Vwcxas CXA on CTA.num_proc_hia=cxa.num_proc_hia and CTA.cd_tp_Tx=cxa.cd_tp_Tx and CTA.dc_hia=cxa.dc_hia
					where
						ETA_Master between @DataInicial and @DataFinal And
						(apelido like @agente or @agente='')
					Group by hou.num_proc_him,Nome_Raz_Soc,eta_master ,cta.cd_tp_moeda


		update @Resultado set Valor=cast(dbo.[FConverterMoeda](Moeda,@MoedaDestino)*Valor as Decimal(10,2))
					--select * from @Resultado
					select 
						Agente,
						sum((Valor)*(isnull(C1.IDMes,0)/Isnull(C1.IDMes,1))) C1,
						sum((Valor)*(isnull(C2.IDMes,0)/Isnull(C2.IDMes,1))) C2,
						sum((Valor)*(isnull(C3.IDMes,0)/Isnull(C3.IDMes,1))) C3,
						sum((Valor)*(isnull(C4.IDMes,0)/Isnull(C4.IDMes,1))) C4,
						sum((Valor)*(isnull(C5.IDMes,0)/Isnull(C5.IDMes,1))) C5,
						sum((Valor)*(isnull(C6.IDMes,0)/Isnull(C6.IDMes,1))) C6,
						sum((Valor)*(isnull(C7.IDMes,0)/Isnull(C7.IDMes,1))) C7,
						sum((Valor)*(isnull(C8.IDMes,0)/Isnull(C8.IDMes,1))) C8,
						sum((Valor)*(isnull(C9.IDMes,0)/Isnull(C9.IDMes,1))) C9,
						sum((Valor)*(isnull(C10.IDMes,0)/Isnull(C10.IDMes,1))) C10,
						sum((Valor)*(isnull(C11.IDMes,0)/Isnull(C11.IDMes,1))) C11,
						sum((Valor)*(isnull(C12.IDMes,0)/Isnull(C12.IDMes,1))) C12
					from 
						@Resultado RS
						Left Join @Colunas C1 on C1.idmes=1 and year(c1.mesano)=year(date) and Month(c1.mesano)=month(date)
						Left Join @Colunas C2 on C2.idmes=2 and year(c2.mesano)=year(date) and Month(c2.mesano)=month(date)
						Left Join @Colunas C3 on C3.idmes=3 and year(c3.mesano)=year(date) and Month(c3.mesano)=month(date)
						Left Join @Colunas C4 on C4.idmes=4 and year(c4.mesano)=year(date) and Month(c4.mesano)=month(date)
						Left Join @Colunas C5 on C5.idmes=5 and year(c5.mesano)=year(date) and Month(c5.mesano)=month(date)
						Left Join @Colunas C6 on C6.idmes=6 and year(c6.mesano)=year(date) and Month(c6.mesano)=month(date)
						Left Join @Colunas C7 on C7.idmes=7 and year(c7.mesano)=year(date) and Month(c7.mesano)=month(date)
						Left Join @Colunas C8 on C8.idmes=8 and year(c8.mesano)=year(date) and Month(c8.mesano)=month(date)
						Left Join @Colunas C9 on C9.idmes=9 and year(c9.mesano)=year(date) and Month(c9.mesano)=month(date)
						Left Join @Colunas C10 on C10.idmes=10 and year(c10.mesano)=year(date) and Month(c10.mesano)=month(date)
						Left Join @Colunas C11 on C11.idmes=11 and year(c11.mesano)=year(date) and Month(c11.mesano)=month(date)
						Left Join @Colunas C12 on C12.idmes=12 and year(c12.mesano)=year(date) and Month(c12.mesano)=month(date)
					Group by
						Agente
		End
	End


if @Parametro='W'
		Begin
		Set @DataInicial=getdate()-90

		Set @Datafinal=getdate()

		set @IntI=1

		Insert @Colunas values(datepart(ww,getdate()),getdate())

		While @IntI <=11
			Begin
				Insert @Colunas values(datepart(ww,getdate())-@inti,getdate())	
				sET @IntI=@IntI+1
			End
		
		if @Tipo='C' 
			Begin
				Select 'Week ' + cast(idmes as varchar(2)) Colunas  from @Colunas order by idmes 
			End
		Else
				begin
					insert @Resultado

					select 
						hou.num_proc_him,Nome_Raz_Soc,eta_master ETA_Master,cta.cd_tp_moeda,sum(dbo.Valor(vlr_org_hia,cta.dc_hia))
					from 
						House_imp_mar HOU with(nolock)
						Join Master_Imp_mar MAS with(nolock) on mas.num_proc_mim=hou.num_proc_mim and hou.num_proc_mim <> 'JOB'
						Join LLP_Master LLP  with(nolock) on LLP.num_proc_master=mas.num_proc_mim
						Join Pessoa PP on pp.cd_pes=cd_export_mim
						Join vwcta_Cte CTA on CTa.num_proc_hia=hou.num_proc_him
						LEft Join Vwcxas CXA on CTA.num_proc_hia=cxa.num_proc_hia and CTA.cd_tp_Tx=cxa.cd_tp_Tx and CTA.dc_hia=cxa.dc_hia
					where
						ETA_Master between @DataInicial and @DataFinal And
						(apelido like @agente or @agente='')
						and cxa.Num_LCto is null
						and desp_org_hia='N'
					Group by hou.num_proc_him,Nome_Raz_Soc,eta_master ,cta.cd_tp_moeda



					Union all


					select 
						hou.num_proc_him,Nome_Raz_Soc,eta_master ETA_Master,'REL',sum(dbo.Valor(Vlr_Pgto_Rcto_Hia,cta.dc_hia))
					from 
						House_imp_mar HOU with(nolock)
						Join Master_Imp_mar MAS with(nolock) on mas.num_proc_mim=hou.num_proc_mim and hou.num_proc_mim <> 'JOB'
						Join LLP_Master LLP  with(nolock) on LLP.num_proc_master=mas.num_proc_mim
						Join Pessoa PP on pp.cd_pes=cd_export_mim
						Join vwcta_Cte CTA on CTa.num_proc_hia=hou.num_proc_him
						Join Vwcxas CXA on CTA.num_proc_hia=cxa.num_proc_hia and CTA.cd_tp_Tx=cxa.cd_tp_Tx and CTA.dc_hia=cxa.dc_hia
					where
						ETA_Master between @DataInicial and @DataFinal And
						(apelido like @agente or @agente='')
					Group by hou.num_proc_him,Nome_Raz_Soc,eta_master ,cta.cd_tp_moeda

		update @Resultado set Valor=cast(dbo.[FConverterMoeda](Moeda,@MoedaDestino)*Valor as Decimal(10,2))
					--select * from @Resultado
					select 
						Agente,
						sum((Valor)*(isnull(C1.IDMes,0)/Isnull(C1.IDMes,1))) C1,
						sum((Valor)*(isnull(C2.IDMes,0)/Isnull(C2.IDMes,1))) C2,
						sum((Valor)*(isnull(C3.IDMes,0)/Isnull(C3.IDMes,1))) C3,
						sum((Valor)*(isnull(C4.IDMes,0)/Isnull(C4.IDMes,1))) C4,
						sum((Valor)*(isnull(C5.IDMes,0)/Isnull(C5.IDMes,1))) C5,
						sum((Valor)*(isnull(C6.IDMes,0)/Isnull(C6.IDMes,1))) C6,
						sum((Valor)*(isnull(C7.IDMes,0)/Isnull(C7.IDMes,1))) C7,
						sum((Valor)*(isnull(C8.IDMes,0)/Isnull(C8.IDMes,1))) C8,
						sum((Valor)*(isnull(C9.IDMes,0)/Isnull(C9.IDMes,1))) C9,
						sum((Valor)*(isnull(C10.IDMes,0)/Isnull(C10.IDMes,1))) C10,
						sum((Valor)*(isnull(C11.IDMes,0)/Isnull(C11.IDMes,1))) C11,
						sum((Valor)*(isnull(C12.IDMes,0)/Isnull(C12.IDMes,1))) C12
					from 
						@Resultado RS
						Left Join @Colunas C1 on C1.idmes=1 and year(c1.mesano)=year(date) and Month(c1.mesano)=month(date)
						Left Join @Colunas C2 on C2.idmes=2 and year(c2.mesano)=year(date) and Month(c2.mesano)=month(date)
						Left Join @Colunas C3 on C3.idmes=3 and year(c3.mesano)=year(date) and Month(c3.mesano)=month(date)
						Left Join @Colunas C4 on C4.idmes=4 and year(c4.mesano)=year(date) and Month(c4.mesano)=month(date)
						Left Join @Colunas C5 on C5.idmes=5 and year(c5.mesano)=year(date) and Month(c5.mesano)=month(date)
						Left Join @Colunas C6 on C6.idmes=6 and year(c6.mesano)=year(date) and Month(c6.mesano)=month(date)
						Left Join @Colunas C7 on C7.idmes=7 and year(c7.mesano)=year(date) and Month(c7.mesano)=month(date)
						Left Join @Colunas C8 on C8.idmes=8 and year(c8.mesano)=year(date) and Month(c8.mesano)=month(date)
						Left Join @Colunas C9 on C9.idmes=9 and year(c9.mesano)=year(date) and Month(c9.mesano)=month(date)
						Left Join @Colunas C10 on C10.idmes=10 and year(c10.mesano)=year(date) and Month(c10.mesano)=month(date)
						Left Join @Colunas C11 on C11.idmes=11 and year(c11.mesano)=year(date) and Month(c11.mesano)=month(date)
						Left Join @Colunas C12 on C12.idmes=12 and year(c12.mesano)=year(date) and Month(c12.mesano)=month(date)
					Group by
						Agente
		End
	End


if @Parametro='D'
		Begin
		Set @DataInicial=getdate()-20

		Set @Datafinal=getdate()

		set @IntI=1

		Insert @Colunas values(datepart(ww,getdate()),getdate())

		While @IntI <=11
			Begin
				Insert @Colunas values(datepart(ww,getdate())-@inti,getdate())	
				sET @IntI=@IntI+1
			End
		
		if @Tipo='C' 
			Begin
					Select datepart(dd,mesano) Colunas from @Colunas order by idmes desc
			End
		Else
				begin
					insert @Resultado

					select 
						hou.num_proc_him,Nome_Raz_Soc,eta_master ETA_Master,cta.cd_tp_moeda,sum(dbo.Valor(vlr_org_hia,cta.dc_hia))
					from 
						House_imp_mar HOU with(nolock)
						Join Master_Imp_mar MAS with(nolock) on mas.num_proc_mim=hou.num_proc_mim and hou.num_proc_mim <> 'JOB'
						Join LLP_Master LLP  with(nolock) on LLP.num_proc_master=mas.num_proc_mim
						Join Pessoa PP on pp.cd_pes=cd_export_mim
						Join vwcta_Cte CTA on CTa.num_proc_hia=hou.num_proc_him
						LEft Join Vwcxas CXA on CTA.num_proc_hia=cxa.num_proc_hia and CTA.cd_tp_Tx=cxa.cd_tp_Tx and CTA.dc_hia=cxa.dc_hia
					where
						ETA_Master between @DataInicial and @DataFinal And
						(apelido like @agente or @agente='')
						and cxa.Num_LCto is null
						and desp_org_hia='N'
					Group by hou.num_proc_him,Nome_Raz_Soc,eta_master ,cta.cd_tp_moeda



					Union all


					select 
						hou.num_proc_him,Nome_Raz_Soc,eta_master ETA_Master,'REL',sum(dbo.Valor(Vlr_Pgto_Rcto_Hia,cta.dc_hia))
					from 
						House_imp_mar HOU with(nolock)
						Join Master_Imp_mar MAS with(nolock) on mas.num_proc_mim=hou.num_proc_mim and hou.num_proc_mim <> 'JOB'
						Join LLP_Master LLP  with(nolock) on LLP.num_proc_master=mas.num_proc_mim
						Join Pessoa PP on pp.cd_pes=cd_export_mim
						Join vwcta_Cte CTA on CTa.num_proc_hia=hou.num_proc_him
						Join Vwcxas CXA on CTA.num_proc_hia=cxa.num_proc_hia and CTA.cd_tp_Tx=cxa.cd_tp_Tx and CTA.dc_hia=cxa.dc_hia
					where
						ETA_Master between @DataInicial and @DataFinal And
						(apelido like @agente or @agente='')
					Group by hou.num_proc_him,Nome_Raz_Soc,eta_master ,cta.cd_tp_moeda

					update @Resultado set Valor=cast(dbo.[FConverterMoeda](Moeda,@MoedaDestino)*Valor as Decimal(10,2))
					--select * from @Resultado
					select 
						Agente,
						sum((Valor)*(isnull(C1.IDMes,0)/Isnull(C1.IDMes,1))) C1,
						sum((Valor)*(isnull(C2.IDMes,0)/Isnull(C2.IDMes,1))) C2,
						sum((Valor)*(isnull(C3.IDMes,0)/Isnull(C3.IDMes,1))) C3,
						sum((Valor)*(isnull(C4.IDMes,0)/Isnull(C4.IDMes,1))) C4,
						sum((Valor)*(isnull(C5.IDMes,0)/Isnull(C5.IDMes,1))) C5,
						sum((Valor)*(isnull(C6.IDMes,0)/Isnull(C6.IDMes,1))) C6,
						sum((Valor)*(isnull(C7.IDMes,0)/Isnull(C7.IDMes,1))) C7,
						sum((Valor)*(isnull(C8.IDMes,0)/Isnull(C8.IDMes,1))) C8,
						sum((Valor)*(isnull(C9.IDMes,0)/Isnull(C9.IDMes,1))) C9,
						sum((Valor)*(isnull(C10.IDMes,0)/Isnull(C10.IDMes,1))) C10,
						sum((Valor)*(isnull(C11.IDMes,0)/Isnull(C11.IDMes,1))) C11,
						sum((Valor)*(isnull(C12.IDMes,0)/Isnull(C12.IDMes,1))) C12
					from 
						@Resultado RS
						Left Join @Colunas C1 on C1.idmes=1 and year(c1.mesano)=year(date) and Month(c1.mesano)=month(date)
						Left Join @Colunas C2 on C2.idmes=2 and year(c2.mesano)=year(date) and Month(c2.mesano)=month(date)
						Left Join @Colunas C3 on C3.idmes=3 and year(c3.mesano)=year(date) and Month(c3.mesano)=month(date)
						Left Join @Colunas C4 on C4.idmes=4 and year(c4.mesano)=year(date) and Month(c4.mesano)=month(date)
						Left Join @Colunas C5 on C5.idmes=5 and year(c5.mesano)=year(date) and Month(c5.mesano)=month(date)
						Left Join @Colunas C6 on C6.idmes=6 and year(c6.mesano)=year(date) and Month(c6.mesano)=month(date)
						Left Join @Colunas C7 on C7.idmes=7 and year(c7.mesano)=year(date) and Month(c7.mesano)=month(date)
						Left Join @Colunas C8 on C8.idmes=8 and year(c8.mesano)=year(date) and Month(c8.mesano)=month(date)
						Left Join @Colunas C9 on C9.idmes=9 and year(c9.mesano)=year(date) and Month(c9.mesano)=month(date)
						Left Join @Colunas C10 on C10.idmes=10 and year(c10.mesano)=year(date) and Month(c10.mesano)=month(date)
						Left Join @Colunas C11 on C11.idmes=11 and year(c11.mesano)=year(date) and Month(c11.mesano)=month(date)
						Left Join @Colunas C12 on C12.idmes=12 and year(c12.mesano)=year(date) and Month(c12.mesano)=month(date)
					Group by
						Agente
		End
	End


GO
