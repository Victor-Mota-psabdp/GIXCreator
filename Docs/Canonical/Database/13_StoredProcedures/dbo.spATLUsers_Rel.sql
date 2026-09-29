SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE Procedure [dbo].[spATLUsers_Rel] --'M','C','%'
		@Parametro	char(1),
		@Tipo		Char(1),
		@Usuario	Varchar(40)


as

/*
	Parametro =
			W = 12 Semanas
			M = 12 Meses
			D = 12 Dias
	Tipo =
			C = Cabeçalho
			D = Dados

*/
SET NOCOUNT ON;
Declare @Resultado table 
	(
		Usuario	VArchar(50),
		Job	Varchar(16),
		Hora	Int,
		Tipo	Varchar(50),
		Date	Varchar(10)

	)

Declare @Colunas Table
	(
		IDMes	Int,
		MesAno	Datetime
	)


Declare @DataInicial Datetime
Declare @DataFinal	Datetime
Declare @Mes	Int
Declare @Ano	INT
Declare @IntI	INT
Declare @DataTemp	Datetime

Set @mes=(12-month(getdate()))
--
--if @Mes <=0 
--	Begin
--		Set @Mes=12-month(getdate())
--	End


set @DataTemp = (select dateadd(month,-11,getdate()))

Set @DataInicial=cast(year(@DataTemp) as varchar(4)) + '-' + right('0' + cast(month(@DataTemp) as varchar(2)),2)  +  '-01'


Set @Datafinal=getdate()


if @Parametro='M'
	Begin


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
				insert @Resultado
				select 
					Distinct nome_usuario,hsgprocesso,datepart(hh,hsgdata) H,Nome_tp_ocor,convert(varchar(10),hsgdata,105) Data 
				from 
					hist_geral_sistema  H With(nolock)
					Join Usuario US  With(nolock) on US.cd_usuario=H.cd_usuario
					Join Tipo_ocorrencia TP   With(nolock) on TP.cd_Tp_ocor=h.cd_tp_ocor
				Where
					(H.cd_tp_ocor=47 or H.cd_tp_ocor=46)
					and hsgdata between @datainicial and @datafinal
					and ( nome_usuario=@usuario or @usuario='%')
					and len(hsgprocesso)=16

				update @resultado set Tipo='Job Creation'
				Where Tipo='Inclusão do Processo'
				
				update @resultado set Tipo='Job Updating'
				Where Tipo='Alteração do Processo'
				

				SET NOCOUNT OFF;
				Select 
						usuario,Tipo,count(C1.idmes) C1,count(C2.idmes) C2,count(C3.idmes) C3,count(C4.idmes) C4,count(C5.idmes) C5,
					count(C6.idmes) C6,count(C7.idmes) C7, count(C8.idmes) C8, count(C9.idmes) C9,count(C10.idmes) C10,count(C11.idmes) C11,count(C12.idmes) C12
				from @Resultado
						Left Join @Colunas C1 on  datepart(ww,getdate()-11)= datepart(ww,(convert(Datetime,Date,103))) and C1.idmes=datepart(ww,getdate()-11)
						Left Join @Colunas C2 on C2.idmes=2 and year(c2.mesano)=year(convert(Datetime,Date,103)) and month(c2.mesano)=month(convert(Datetime,Date,103)) 
						Left Join @Colunas C3 on C3.idmes=3 and year(c3.mesano)=year(convert(Datetime,Date,103)) and month(c3.mesano)=month(convert(Datetime,Date,103)) 
						Left Join @Colunas C4 on C4.idmes=4 and year(c4.mesano)=year(convert(Datetime,Date,103)) and month(c4.mesano)=month(convert(Datetime,Date,103)) 
						Left Join @Colunas C5 on C5.idmes=5 and year(c5.mesano)=year(convert(Datetime,Date,103)) and month(c5.mesano)=month(convert(Datetime,Date,103)) 
						Left Join @Colunas C6 on C6.idmes=6 and year(c6.mesano)=year(convert(Datetime,Date,103)) and month(c6.mesano)=month(convert(Datetime,Date,103)) 
						Left Join @Colunas C7 on C7.idmes=7 and year(c7.mesano)=year(convert(Datetime,Date,103)) and month(c7.mesano)=month(convert(Datetime,Date,103)) 
						Left Join @Colunas C8 on C8.idmes=8 and year(c8.mesano)=year(convert(Datetime,Date,103)) and month(c8.mesano)=month(convert(Datetime,Date,103)) 
						Left Join @Colunas C9 on C9.idmes=9 and year(c9.mesano)=year(convert(Datetime,Date,103)) and month(c9.mesano)=month(convert(Datetime,Date,103))
						Left Join @Colunas C10 on C10.idmes=10 and year(c10.mesano)=year(convert(Datetime,Date,103)) and month(c10.mesano)=month(convert(Datetime,Date,103))
						Left Join @Colunas C11 on C11.idmes=11 and year(c11.mesano)=year(convert(Datetime,Date,103)) and month(c11.mesano)=month(convert(Datetime,Date,103))
						Left Join @Colunas C12 on C12.idmes=12 and year(c12.mesano)=year(convert(Datetime,Date,103)) and month(c12.mesano)=month(convert(Datetime,Date,103))
				group by 
					usuario,Tipo
		End
	End



if @Parametro='W'
	Begin
		

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
					Distinct nome_usuario,hsgprocesso,datepart(hh,hsgdata) H,Nome_tp_ocor,convert(varchar(10),hsgdata,105) Data 
				from 
					hist_geral_sistema H with(nolock)
					Join Usuario US with(nolock) on US.cd_usuario=H.cd_usuario
					Join Tipo_ocorrencia TP with(nolock) on TP.cd_Tp_ocor=h.cd_tp_ocor
				Where
					H.cd_tp_ocor in (47,46)
					and hsgdata between @datainicial and @datafinal
					and nome_usuario like @usuario


				update @resultado set Tipo='Job Creation'
				Where Tipo='Inclusão do Processo'
				
				update @resultado set Tipo='Job Updating'
				Where Tipo='Alteração do Processo'

				SET NOCOUNT OFF;
				Select 
						usuario,Tipo,count(C1.idmes) C1,count(C2.idmes) C2,count(C3.idmes) C3,count(C4.idmes) C4,count(C5.idmes) C5,
					count(C6.idmes) C6,count(C7.idmes) C7, count(C8.idmes) C8, count(C9.idmes) C9,count(C10.idmes) C10,count(C11.idmes) C11,count(C12.idmes) C12
				from @Resultado
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
				group by 
					usuario,Tipo
		End
	End



if @Parametro='D'
	Begin
		

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
					Distinct nome_usuario,hsgprocesso,datepart(hh,hsgdata) H,Nome_tp_ocor,convert(varchar(10),hsgdata,105) Data 
				from 
					hist_geral_sistema H with(nolock)
					Join Usuario US with(nolock) on US.cd_usuario=H.cd_usuario
					Join Tipo_ocorrencia TP with(nolock) on TP.cd_Tp_ocor=h.cd_tp_ocor
				Where
					H.cd_tp_ocor in (47,46)
					and hsgdata between @datainicial and @datafinal
					and nome_usuario like @usuario
				
				update @resultado set Tipo='Job Creation'
				Where Tipo='Inclusão do Processo'
				
				update @resultado set Tipo='Job Updating'
				Where Tipo='Alteração do Processo'

				SET NOCOUNT OFF;
				Select 
						usuario,Tipo,count(C1.idmes) C1,count(C2.idmes) C2,count(C3.idmes) C3,count(C4.idmes) C4,count(C5.idmes) C5,
					count(C6.idmes) C6,count(C7.idmes) C7, count(C8.idmes) C8, count(C9.idmes) C9,count(C10.idmes) C10,count(C11.idmes) C11,count(C12.idmes) C12
				from @Resultado
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


				group by 
					usuario,Tipo
		End
	End





GO
