SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spFluxoCaixa_Rel 'C','2011-09-01', '2011-09-01'


CREATE Procedure [dbo].[spFluxoCaixa_Rel] --'D','2011-09-01','2011-09-28'

	@Tipo		varchar(1),
	@DtInicial	datetime,
	@DtFinal	datetime

as

	SET NOCOUNT ON;

	Declare @Colunas Table
		(
			IDMes	Int,
			MesAno	Datetime
		)

	Declare @Resultado table
		(
		Data	datetime,
		Caixa	varchar(50),
		Valor	float
		)
		
	Declare @IntI	INT

			set @IntI=1
			Insert @Colunas values(@inti,convert(varchar(10),@DtInicial,101))	

			While @IntI <=30
				Begin
					sET @IntI=@IntI+1
					Insert @Colunas values(@inti,convert(varchar(10),@DtInicial+@inti-1,101))	
				End

		insert @Resultado 
			select  convert(datetime,PG.Dt_Vcto_Div,103) Data, nomeFluxodeCaixa,sum(dbo.valor(PRD.Vlr_item,dc_ITEM)) Valor from 
			Pgto_Rcto_Div PG
			left join Pgto_Rcto_Div_Det PRD on PRD.Num_Lcto_Div = PG.Num_Lcto_Div
			left join Cta_Ctb			CC  on CC.Cd_Cta_Ctb = PRD.Cd_Cta_Ctb
			left join FluxodeCaixa		FC  on FC.Cd_FluxodeCaixa = CC.Cd_FluxodeCaixa
			where convert(datetime,Dt_Vcto_Div,103) between @DtInicial and @DtFinal
			group by PG.Dt_Vcto_Div, nomeFluxodeCaixa
			order by 1

--	SET NOCOUNT OFF;
		
		if @Tipo = 'C'
			Begin 				
				Select cast(day(mesano)as varchar(2)) + '/' + cast(month(mesano)as varchar(2)) Colunas from @Colunas order by idmes 				
			end
		else
			begin
				select
					Rs.Caixa Conta,
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
					sum((Valor)*(isnull(C12.IDMes,0)/Isnull(C12.IDMes,1))) C12,
					sum((Valor)*(isnull(C13.IDMes,0)/Isnull(C13.IDMes,1))) C13,
					sum((Valor)*(isnull(C14.IDMes,0)/Isnull(C14.IDMes,1))) C14,
					sum((Valor)*(isnull(C15.IDMes,0)/Isnull(C15.IDMes,1))) C15,
					sum((Valor)*(isnull(C16.IDMes,0)/Isnull(C16.IDMes,1))) C16,
					sum((Valor)*(isnull(C17.IDMes,0)/Isnull(C17.IDMes,1))) C17,
					sum((Valor)*(isnull(C18.IDMes,0)/Isnull(C18.IDMes,1))) C18,
					sum((Valor)*(isnull(C19.IDMes,0)/Isnull(C19.IDMes,1))) C19,
					sum((Valor)*(isnull(C20.IDMes,0)/Isnull(C20.IDMes,1))) C20,
					sum((Valor)*(isnull(C21.IDMes,0)/Isnull(C21.IDMes,1))) C21,
					sum((Valor)*(isnull(C22.IDMes,0)/Isnull(C22.IDMes,1))) C22,
					sum((Valor)*(isnull(C23.IDMes,0)/Isnull(C23.IDMes,1))) C23,
					sum((Valor)*(isnull(C24.IDMes,0)/Isnull(C24.IDMes,1))) C24,
					sum((Valor)*(isnull(C25.IDMes,0)/Isnull(C25.IDMes,1))) C25,
					sum((Valor)*(isnull(C26.IDMes,0)/Isnull(C26.IDMes,1))) C26,
					sum((Valor)*(isnull(C27.IDMes,0)/Isnull(C27.IDMes,1))) C27,
					sum((Valor)*(isnull(C28.IDMes,0)/Isnull(C28.IDMes,1))) C28,
					sum((Valor)*(isnull(C29.IDMes,0)/Isnull(C29.IDMes,1))) C29,
					sum((Valor)*(isnull(C30.IDMes,0)/Isnull(C30.IDMes,1))) C30
				from
					@Resultado RS
					Left Join @Colunas C1 on C1.idmes=1 and C1.mesano=Data
					Left Join @Colunas C2 on C2.idmes=2 and C2.mesano=Data
					Left Join @Colunas C3 on C3.idmes=3 and C3.mesano=Data
					Left Join @Colunas C4 on C4.idmes=4 and C4.mesano=Data
					Left Join @Colunas C5 on C5.idmes=5 and C5.mesano=Data
					Left Join @Colunas C6 on C6.idmes=6 and C6.mesano=Data
					Left Join @Colunas C7 on C7.idmes=7 and C6.mesano=Data
					Left Join @Colunas C8 on C8.idmes=8 and C8.mesano=Data
					Left Join @Colunas C9 on C9.idmes=9 and C9.mesano=Data
					Left Join @Colunas C10 on C10.idmes=10 and C10.mesano=Data
					Left Join @Colunas C11 on C11.idmes=11 and C11.mesano=Data
					Left Join @Colunas C12 on C12.idmes=12 and C12.mesano=Data
					Left Join @Colunas C13 on C13.idmes=13 and C13.mesano=Data
					Left Join @Colunas C14 on C14.idmes=14 and C14.mesano=Data
					Left Join @Colunas C15 on C15.idmes=15 and C15.mesano=Data
					Left Join @Colunas C16 on C16.idmes=16 and C16.mesano=Data
					Left Join @Colunas C17 on C17.idmes=17 and C17.mesano=Data
					Left Join @Colunas C18 on C18.idmes=18 and C18.mesano=Data
					Left Join @Colunas C19 on C19.idmes=19 and C19.mesano=Data
					Left Join @Colunas C20 on C20.idmes=20 and C20.mesano=Data
					Left Join @Colunas C21 on C21.idmes=21 and C21.mesano=Data
					Left Join @Colunas C22 on C22.idmes=22 and C22.mesano=Data
					Left Join @Colunas C23 on C23.idmes=23 and C23.mesano=Data
					Left Join @Colunas C24 on C24.idmes=24 and C24.mesano=Data
					Left Join @Colunas C25 on C25.idmes=25 and C25.mesano=Data
					Left Join @Colunas C26 on C26.idmes=26 and C26.mesano=Data
					Left Join @Colunas C27 on C27.idmes=27 and C27.mesano=Data
					Left Join @Colunas C28 on C28.idmes=28 and C28.mesano=Data
					Left Join @Colunas C29 on C29.idmes=29 and C29.mesano=Data
					Left Join @Colunas C30 on C30.idmes=30 and C30.mesano=Data
				group by
					RS.Caixa,Data
			end






GO
