SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spATL_BLSTXTAGT_Sel] '2013-03-01','2013-03-31'

create procedure [dbo].[spATL_BLSTXTAGT_Sel] 
	
	@DataInicial datetime,
	@DataFinal datetime
	
AS


SET NOCOUNT ON
		Declare @TAB Table --1
				(
					[Num_Lcto_Div] varchar(17),
					[Tipo de Registro] int,
					[Tipo de Lancamento] varchar(2),
					[Conta Reduzida] varchar(7), 
					[Codigo Centro de Custo] varchar(42),
					[Natureza Sub Lancamento] varchar(1),
					[Data]	varchar(4),
					[Valor] varchar(17),
					[Historico Padrao] varchar(200),
					[Complemento] varchar(200)
					)
	Declare @NumLctoDiv	varchar(17)
	Declare @DC_Item Varchar(1)
	Declare @Num_Lcto_Div Varchar(17)
	Declare	@Cd_Cta_Ctb_Red varchar(7)
	
Declare C_NumLctoDiv cursor for
--Busca Numeros do JOB conforme datas Informadas (Apenas JOBs que contem lançamentos de AGENTE)
	select num_proc_hem JOB from ctA_ctE_hou_exp_mar CTA
	join Pessoa PS on CTA.Cd_Cred_dev_hem = PS.Cd_Pes and (PS.Cd_Tp_Ativ = 'AGT' or PS.Cd_Tp_Classe = 'AGT' or PS.Cd_Tp_Grupo = 'AGT')
	where CTA.num_proc_hem = 'EMATL201208007BR' --and between @DataInicial and @DataFinal 
	group by num_proc_hem
	
Open C_NumLctoDiv
SET NOCOUNT ON
Fetch Next From C_NumLctoDiv Into @NumLctoDiv
	While @@FETCH_STATUS = 0
		Begin
			If left(@NumLctoDiv,2) = 'EM'
				Begin
---Calcula Valores Por TAXAS de AGENTE
					update 
						CTA
					set
						CTA.Vlr_Contab = dbo.VerParidade(convert(varchar,CTA.Dt_Prev_Pgto_Hem,103),CTA.Cd_Tp_Moeda,'OFC')* dbo.Valor(convert(decimal(15,2),CTA.Vlr_Org_Hem),CTA.DC_Hem) 
					from
						Cta_Cte_Hou_Exp_MAr CTA
						join Pessoa PS on CTA.Cd_Cred_dev_hem = PS.Cd_Pes and (PS.Cd_Tp_Ativ = 'AGT' or PS.Cd_Tp_Classe = 'AGT' or PS.Cd_Tp_Grupo = 'AGT')
					where 
						Num_Proc_Hem = @NumLctoDiv
				End
				
---Guarda na tabela temporaria o REGISTRO TIPO 1
			Insert into @TAB
				select 
					Num_proc_hem [Num_Lcto_Div],
					1 [Tipo de Registro],
					'MM' [Tipo de Lancamento],
					NULL [Conta Reduzida],
					NULL [Codigo Centro de Custo],
					NULL [Natureza Sub Lancamento],
					replace(substring(convert(varchar,getdate(),103),1,5),'/','')  [Data],
					--Sum(dbo.VerParidade(convert(varchar,FAT.FatDtVenc,103),Cd_Tp_Moeda,'OFC')* dbo.Valor(convert(decimal(15,2),IFAT.Vlr_Org),IFAT.DC))  [Valor],
					sum(Vlr_Contab) [Valor],
					NULL [Historico Padrao],
					--'00000' [Historico Padrao],
					NULL [Complemento]
					--@NumLctoDiv[Complemento]
				from Cta_Cte_Hou_exp_Mar CTA with(nolock)
				join Pessoa PS on CTA.Cd_Cred_dev_hem = PS.Cd_Pes and (PS.Cd_Tp_Ativ = 'AGT' or PS.Cd_Tp_Classe = 'AGT' or PS.Cd_Tp_Grupo = 'AGT')
				where CTA.Num_proc_hem = @NumLctoDiv --and IFAT.DC = 'C'
				group by CTA.Num_proc_hem 

---Guarda na tabela temporaria o REGISTRO TIPO 2 - CREDITO	
				Insert into @TAB
					select 
						TAB.Num_Lcto_Div [Num_Lcto_Div],
						2 [Tipo de Registro],
						NULL [Tipo de Lancamento],
						'22400' [Conta Reduzida],
						NULL [Codigo Centro de Custo],
						'C' [Natureza Sub Lancamento],
						NULL [Data],
						TAB.Valor [Valor],
						'00104' [Historico Padrao],
						TAB.Num_Lcto_Div + ' - ' + UPPER(max(PS.Nome_Raz_Soc)) [Complemento]
					from @TAB TAB 
					join Cta_Cte_Hou_Exp_Mar CTA on TAB.Num_Lcto_Div = CTA.Num_proc_hem
					join Pessoa PS on CTA.Cd_Cred_dev_hem = PS.Cd_Pes and (PS.Cd_Tp_Ativ = 'AGT' or PS.Cd_Tp_Classe = 'AGT' or PS.Cd_Tp_Grupo = 'AGT')
					where TAB.Num_Lcto_Div = @NumLctoDiv and [Tipo de Registro] = 1 --and PRD.DC_Div = 'D'
					group by TAB.Num_Lcto_Div,TAB.Valor
					
---Guarda na tabela temporaria o REGISTRO TIPO 2 - DEBITO													
				Insert into @TAB
					select 
						TAB.Num_Lcto_Div [Num_Lcto_Div],
						2 [Tipo de Registro],
						NULL [Tipo de Lancamento],
						'11155' [Conta Reduzida],
						NULL [Codigo Centro de Custo],
						'D' [Natureza Sub Lancamento],
						NULL [Data],
						TAB.Valor [Valor],
						'00104' [Historico Padrao],
						TAB.Num_Lcto_Div + ' - ' + UPPER(max(PS.Nome_Raz_Soc)) [Complemento]
					from @TAB TAB 
					join Cta_Cte_Hou_Exp_Mar CTA on TAB.Num_Lcto_Div = CTA.Num_Proc_Hem
					join Pessoa PS on CTA.Cd_Cred_dev_hem = PS.Cd_Pes and (PS.Cd_Tp_Ativ = 'AGT' or PS.Cd_Tp_Classe = 'AGT' or PS.Cd_Tp_Grupo = 'AGT')
					where TAB.Num_Lcto_Div = @NumLctoDiv and [Tipo de Registro] = 1 --and PRD.DC_Div = 'D'
					group by TAB.Num_Lcto_Div,TAB.Valor
			
			Fetch Next From C_NumLctoDiv Into @NumLctoDiv
		End
close C_NumLctoDiv
deallocate C_NumLctoDiv 



			update
				@TAB
				Set
					[Conta Reduzida] = replace(str([Conta Reduzida],7),' ','0')
			where
				[Tipo de Registro] = 2
								
			update
				@TAB
				Set 
				[Valor] = dbo.PreencheString(replace(convert(decimal(10,2),[Valor]),'.',','),17,'0'),
				[Complemento ]= RTRIM(replace([Complemento] COLLATE Latin1_General_BIN, char(10),''))
			update
				@TAB
				Set 
				[Complemento ]= RTRIM(replace([Complemento] COLLATE Latin1_General_BIN, char(9),''))
			update
				@TAB
				Set 
				[Complemento ]= RTRIM(replace([Complemento] COLLATE Latin1_General_BIN, char(13),''))
	
Select * from @TAB

GO
