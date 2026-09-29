SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE Procedure [dbo].[spATLVolumeAirExp_Sel] --'M','D',''
			@Parametro	Char(1),
			@Tipo		Char(1),
			@Agente		Varchar(40)

AS

Declare		@DataInicial	Datetime
Declare		@DataFinal		Datetime
Declare		@Mes			Int
Declare		@Ano			Int
Declare		@IntI			Int
Declare		@DataTemp		Datetime

SET NOCOUNT ON;
Declare @Resultado table 
	(
		Agente	VArchar(50),
		Teus	float,
		Date	Datetime,
		Regiao	varchar(40),
		Modal	Varchar(40)
	)

Declare @Colunas Table
	(
		IDMes	Int,
		MesAno	Datetime
	)


if @Parametro='M'
	Begin
--		Set @mes=(month(getdate())-11)*-1
--		if month(getdate())<12 
--			begin
--				set @Ano=year(Getdate())-1
--			End
		--Set @DataInicial=cast(@ano as varchar(4)) +'-' + right('0' + cast(@mes as varchar(4)),2)  +  '-01'

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
			Begin

				Insert @Resultado

				select 
					apelido,peso_real_hea,eta_master ETA_Master,nome_regiao,'Air Import'
				from 
					House_exp_aer HOU with(nolock)
					Join Master_exp_aer MAS with(nolock) on mas.num_proc_mea=hou.num_proc_mea and hou.num_proc_mea <> 'JOB'
					Join LLP_Master LLP  with(nolock) on LLP.num_proc_master=mas.num_proc_mea
					Join Pessoa PP on pp.cd_pes=cd_export_mea
					Join Localidade Org on Org.cd_local=cd_org_hea
					Join Regiao RG on RG.cd_regiao=Org.cd_regiao
				where
					ETA_Master between @DataInicial and @DataFinal And
					(apelido = @agente or @agente='')

				Union all

				select 
					apelido,peso_real_hea,eta_master ETA_Master,nome_regiao,'Air Export'
				from 
					House_exp_aer HOU with(nolock)
					Join Master_exp_aer MAS with(nolock) on mas.num_proc_mea=hou.num_proc_mea and hou.num_proc_mea <> 'JOB'
					Join LLP_Master LLP  with(nolock) on LLP.num_proc_master=mas.num_proc_mea
					Join Pessoa PP on pp.cd_pes=cd_consig_mea
					Join Localidade Org on Org.cd_local=cd_dst_hea
					Join Regiao RG on RG.cd_regiao=Org.cd_regiao
				where
					ETA_Master between @DataInicial and @DataFinal And
					(apelido = @agente or @agente='')


				select 
					Agente,
					sum((teus)*(isnull(C1.IDMes,0)/Isnull(C1.IDMes,1))) C1,
					sum((teus)*(isnull(C2.IDMes,0)/Isnull(C2.IDMes,1))) C2,
					sum((teus)*(isnull(C3.IDMes,0)/Isnull(C3.IDMes,1))) C3,
					sum((teus)*(isnull(C4.IDMes,0)/Isnull(C4.IDMes,1))) C4,
					sum((teus)*(isnull(C5.IDMes,0)/Isnull(C5.IDMes,1))) C5,
					sum((teus)*(isnull(C6.IDMes,0)/Isnull(C6.IDMes,1))) C6,
					sum((teus)*(isnull(C7.IDMes,0)/Isnull(C7.IDMes,1))) C7,
					sum((teus)*(isnull(C8.IDMes,0)/Isnull(C8.IDMes,1))) C8,
					sum((teus)*(isnull(C9.IDMes,0)/Isnull(C9.IDMes,1))) C9,
					sum((teus)*(isnull(C10.IDMes,0)/Isnull(C10.IDMes,1))) C10,
					sum((teus)*(isnull(C11.IDMes,0)/Isnull(C11.IDMes,1))) C11,
					sum((teus)*(isnull(C12.IDMes,0)/Isnull(C12.IDMes,1))) C12,
					Regiao,Modal
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
					Agente,regiao,modal



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
			Begin
				insert @Resultado

				select 
					apelido,peso_real_hea,eta_master ETA_Master,nome_regiao,'Air Import'
				from 
					House_exp_aer HOU with(nolock)
					Join Master_exp_aer MAS with(nolock) on mas.num_proc_mea=hou.num_proc_mea and hou.num_proc_mea <> 'JOB'
					Join LLP_Master LLP  with(nolock) on LLP.num_proc_master=mas.num_proc_mea
					Join Pessoa PP on pp.cd_pes=cd_export_mea
					Join Localidade Org on Org.cd_local=cd_org_hea
					Join Regiao RG on RG.cd_regiao=Org.cd_regiao
				where
					ETA_Master between @DataInicial and @DataFinal And
					(apelido = @agente or @agente='')

				Union all

				select 
					apelido,peso_real_hea,eta_master ETA_Master,nome_regiao,'Air Export'
				from 
					House_exp_aer HOU with(nolock)
					Join Master_exp_aer MAS with(nolock) on mas.num_proc_mea=hou.num_proc_mea and hou.num_proc_mea <> 'JOB'
					Join LLP_Master LLP  with(nolock) on LLP.num_proc_master=mas.num_proc_mea
					Join Pessoa PP on pp.cd_pes=cd_consig_mea
					Join Localidade Org on Org.cd_local=cd_dst_hea
					Join Regiao RG on RG.cd_regiao=Org.cd_regiao
				where
					ETA_Master between @DataInicial and @DataFinal And
					(apelido = @agente or @agente='')


			select 
				Agente,
				sum((teus)*(isnull(C1.IDMes,0)/Isnull(C1.IDMes,1))) C1,
				sum((teus)*(isnull(C2.IDMes,0)/Isnull(C2.IDMes,1))) C2,
				sum((teus)*(isnull(C3.IDMes,0)/Isnull(C3.IDMes,1))) C3,
				sum((teus)*(isnull(C4.IDMes,0)/Isnull(C4.IDMes,1))) C4,
				sum((teus)*(isnull(C5.IDMes,0)/Isnull(C5.IDMes,1))) C5,
				sum((teus)*(isnull(C6.IDMes,0)/Isnull(C6.IDMes,1))) C6,
				sum((teus)*(isnull(C7.IDMes,0)/Isnull(C7.IDMes,1))) C7,
				sum((teus)*(isnull(C8.IDMes,0)/Isnull(C8.IDMes,1))) C8,
				sum((teus)*(isnull(C9.IDMes,0)/Isnull(C9.IDMes,1))) C9,
				sum((teus)*(isnull(C10.IDMes,0)/Isnull(C10.IDMes,1))) C10,
				sum((teus)*(isnull(C11.IDMes,0)/Isnull(C11.IDMes,1))) C11,
				sum((teus)*(isnull(C12.IDMes,0)/Isnull(C12.IDMes,1))) C12
			from 
				@Resultado RS
				Left Join @Colunas C1 on C1.idmes=datepart(ww,getdate())-11 and C1.idmes=datepart(ww,(convert(Datetime,Date,103)))
				Left Join @Colunas C2 on C2.idmes=datepart(ww,getdate())-10 and C2.idmes=datepart(ww,(convert(Datetime,Date,103)))
				Left Join @Colunas C3 on C3.idmes=datepart(ww,getdate())-9 and C3.idmes=datepart(ww,(convert(Datetime,Date,103)))
				Left Join @Colunas C4 on C4.idmes=datepart(ww,getdate())-8 and C4.idmes=datepart(ww,(convert(Datetime,Date,103)))
				Left Join @Colunas C5 on C5.idmes=datepart(ww,getdate())-7 and C5.idmes=datepart(ww,(convert(Datetime,Date,103)))
				Left Join @Colunas C6 on C6.idmes=datepart(ww,getdate())-6 and C6.idmes=datepart(ww,(convert(Datetime,Date,103)))
				Left Join @Colunas C7 on C7.idmes=datepart(ww,getdate())-5 and C7.idmes=datepart(ww,(convert(Datetime,Date,103)))
				Left Join @Colunas C8 on C8.idmes=datepart(ww,getdate())-4 and C8.idmes=datepart(ww,(convert(Datetime,Date,103)))
				Left Join @Colunas C9 on C9.idmes=datepart(ww,getdate())-3 and C9.idmes=datepart(ww,(convert(Datetime,Date,103)))
				Left Join @Colunas C10 on C10.idmes=datepart(ww,getdate())-2 and C10.idmes=datepart(ww,(convert(Datetime,Date,103)))
				Left Join @Colunas C11 on C11.idmes=datepart(ww,getdate())-1 and C11.idmes=datepart(ww,(convert(Datetime,Date,103)))
				Left Join @Colunas C12 on C12.idmes=datepart(ww,getdate())-9 and C12.idmes=datepart(ww,(convert(Datetime,Date,103)))
			Group by
				Agente
		End
	End


if @Parametro='D'
	Begin
		
		Set @DataInicial=getdate()-15

		Set @Datafinal=getdate()

		set @IntI=1
		Insert @Colunas values(@inti,convert(varchar(10),getdate(),101))	

		While @IntI <=11
			Begin
				sET @IntI=@IntI+1
				Insert @Colunas values(@inti,convert(varchar(10),getdate()-@inti,101))	

			End
		
		if @Tipo='C' 
			Begin
				Select datepart(dd,mesano) Colunas from @Colunas order by idmes desc
			End
		Else
			Begin
				insert @Resultado

				select 
					apelido,peso_real_hea,eta_master ETA_Master,nome_regiao,'Air Import'
				from 
					House_exp_aer HOU with(nolock)
					Join Master_exp_aer MAS with(nolock) on mas.num_proc_mea=hou.num_proc_mea and hou.num_proc_mea <> 'JOB'
					Join LLP_Master LLP  with(nolock) on LLP.num_proc_master=mas.num_proc_mea
					Join Pessoa PP on pp.cd_pes=cd_export_mea
					Join Localidade Org on Org.cd_local=cd_org_hea
					Join Regiao RG on RG.cd_regiao=Org.cd_regiao
				where
					ETA_Master between @DataInicial and @DataFinal And
					(apelido = @agente or @agente='')

				Union all

				select 
					apelido,peso_real_hea,eta_master ETA_Master,nome_regiao,'Air Export'
				from 
					House_exp_aer HOU with(nolock)
					Join Master_exp_aer MAS with(nolock) on mas.num_proc_mea=hou.num_proc_mea and hou.num_proc_mea <> 'JOB'
					Join LLP_Master LLP  with(nolock) on LLP.num_proc_master=mas.num_proc_mea
					Join Pessoa PP on pp.cd_pes=cd_consig_mea
					Join Localidade Org on Org.cd_local=cd_dst_hea
					Join Regiao RG on RG.cd_regiao=Org.cd_regiao
				where
					ETA_Master between @DataInicial and @DataFinal And
					(apelido = @agente or @agente='')


			select 
				Agente,
				sum((teus)*(isnull(C1.IDMes,0)/Isnull(C1.IDMes,1))) C1,
				sum((teus)*(isnull(C2.IDMes,0)/Isnull(C2.IDMes,1))) C2,
				sum((teus)*(isnull(C3.IDMes,0)/Isnull(C3.IDMes,1))) C3,
				sum((teus)*(isnull(C4.IDMes,0)/Isnull(C4.IDMes,1))) C4,
				sum((teus)*(isnull(C5.IDMes,0)/Isnull(C5.IDMes,1))) C5,
				sum((teus)*(isnull(C6.IDMes,0)/Isnull(C6.IDMes,1))) C6,
				sum((teus)*(isnull(C7.IDMes,0)/Isnull(C7.IDMes,1))) C7,
				sum((teus)*(isnull(C8.IDMes,0)/Isnull(C8.IDMes,1))) C8,
				sum((teus)*(isnull(C9.IDMes,0)/Isnull(C9.IDMes,1))) C9,
				sum((teus)*(isnull(C10.IDMes,0)/Isnull(C10.IDMes,1))) C10,
				sum((teus)*(isnull(C11.IDMes,0)/Isnull(C11.IDMes,1))) C11,
				sum((teus)*(isnull(C12.IDMes,0)/Isnull(C12.IDMes,1))) C12
			from 
				@Resultado RS
				Left Join @Colunas C1 on C1.idmes=1 and C1.mesano=(convert(Datetime,Date,103))
				Left Join @Colunas C2 on C2.idmes=2 and C2.mesano=(convert(Datetime,Date,103))
				Left Join @Colunas C3 on C3.idmes=3 and C3.mesano=(convert(Datetime,Date,103))
				Left Join @Colunas C4 on C4.idmes=4 and C4.mesano=(convert(Datetime,Date,103))
				Left Join @Colunas C5 on C5.idmes=5 and C5.mesano=(convert(Datetime,Date,103))
				Left Join @Colunas C6 on C6.idmes=6 and C6.mesano=(convert(Datetime,Date,103))
				Left Join @Colunas C7 on C7.idmes=7 and C7.mesano=(convert(Datetime,Date,103))
				Left Join @Colunas C8 on C8.idmes=8 and C8.mesano=(convert(Datetime,Date,103))
				Left Join @Colunas C9 on C9.idmes=9 and C9.mesano=(convert(Datetime,Date,103))
				Left Join @Colunas C10 on C10.idmes=10 and C10.mesano=(convert(Datetime,Date,103))
				Left Join @Colunas C11 on C11.idmes=11 and C11.mesano=(convert(Datetime,Date,103))
				Left Join @Colunas C12 on C12.idmes=12 and C12.mesano=(convert(Datetime,Date,103))

			Group by
				Agente
		End


	End



GO
