SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spTaxasBDPInvoice_Sel 'IASTL201308001BR', 'STEELCASE'
--spTaxasBDPInvoice_sel 'IAATL201307051BR', 'PPG INDUSTRIA - 1642'
--spTaxasBDPInvoiceErbson_Sel'EMATL201301031BR', 'BDPT'
--incluido o and desat_tx='N' 30-7-2013 cadu
--incluido no case de nf pra nao pega os casos q são: CC.ref_acesso_nf <> 'P'
--spTaxasBDPInvoice_Sel 'EAVCP201301002', 'FEDEX'
--incluido pra não trazer os casos q tem id_ax - cadu 07-04-2014
--incluido verificar a vwSolPgtoCtaCteAprovadas - cadu 07/10/2014
--incluido verificar a data de emissao da nf, pra so trazer o que for do mes  - cadu 30-07-2015
--incluido ser pela vwFaturas - cadu 15-09-2015
--nao trazer adiantamentos - cadu 15-09-2015
--usar view - 15/09/2015
--incluido ver a paridade do fatura Arg det - erbson/cadu - 23/09/15
--incluido ver a paridade do fatura Arg det  num proc X DC x CD_tp_tx - erbson/cadu - 23/10/15

--Antonio 26/01/2023 -  ticket 100-376296 –TRANSPORTATION - Faturamento antecipado 

--26-10-2016 - incluido p trazer o master
--spTaxasBDPInvoice_Sel 'EAGRU201610007', 'ABSA - 1691C'

CREATE procedure [dbo].[spTaxasBDPInvoice_Sel]-- spTaxasBDPInvoice_Sel 'EAGRU201610007', 'ABSA - 1691C'
(
	@Processo varchar(16),
	@Pessoa varchar(50)
)

AS

/*
	Anderson Oliveira - 13/12/2013 - Incluido: relação com tabela Pessoa_ATL_TX
	Por definição do projeto AX, é necessário ter um cliente no AX para emissão da Fatura
*/

SET NOCOUNT ON
	Declare @CdPes varchar(10)
	
	Declare @TempTaxas Table
	(
		Moeda		varchar(3),
		Paridade	float,
		Nome_tp_tx	varchar(50),
		Valor		decimal(10,2),
		cd_tp_tx	varchar(10),
		Cd_Pes		varchar(10),
		DC			varchar(1),
		NF			varchar(12),
		[Site]		varchar(1),
		Repasse_TX	varchar(1),
		Emissao		Datetime	
		,FatVendorInvoiceNumber	varchar(17) --Alessandra 19/05/2021 - AX10
	)
		
	If @Pessoa <> '' 
		begin
				set @cdPes = (Select cd_pes from pessoa where apelido = @Pessoa)
		end
	
	If @Pessoa = ''
		Begin
			Insert @TempTaxas
				SELECT 
					distinct cc.cd_tp_moeda Moeda,
					(case When
							CC.Num_NF_HIA is not NULL
						Then 
							--CC.Par_NF_HIA 
							FARG.Paridade
						else 						
					--dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Paridade,
					(case when LEFT(CC.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM')
						else 
					(case when LEFT(CC.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA')
						else 
					(case when LEFT(CC.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM')
						else 
					(case when LEFT(CC.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')					
						else
							dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') 
					end)end)end)end)end)Paridade,					
					TT.Nome_tp_tx,
					
					--Vlr_Org_HIA*dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Valor,
					(case when LEFT(CC.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM') * Vlr_Org_HIA 
						else 
					(case when LEFT(CC.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA') * Vlr_Org_HIA 
						else 
					(case when LEFT(CC.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') * Vlr_Org_HIA 
						else 
					(case when LEFT(CC.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')	* Vlr_Org_HIA 				
						else
							dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC')  * Vlr_Org_HIA 
					end)end)end)end)Valor,
					
					CC.cd_tp_tx, CC.Cd_Cred_Dev_HIA Cd_Pes,cc.DC_HIA DC 
					,CC.Num_NF_HIA NF, CC.Ref_Acesso_NF_HIA [Site],
					Repasse_TX,
					isnull(FARG.Dt_Fatura,GETDATE()) Emissao
					,fat.FatVendorInvoiceNumber --Alessandra 19/05/2021 - AX10
				FROM 
					vwcta_Cte CC with (nolock)
					left Join Tipo_Taxa TT with (nolock)on CC.cd_tp_tx = TT.cd_tp_tx
					Join vwCliente HOU  with (nolock)on HOU.num_proc = CC.Num_Proc_HIA and HOU.cd_cliente = cc.Cd_Cred_Dev_HIA
					Left join vwCXAS CXA with (nolock)on	CC.Num_Proc_HIA	= CXA.Num_Proc_HIA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.DC_HIA = CXA.DC_HIA and num_lcto <> 'PROVISÓRIO'
					Join Pessoa_ATL_AX P with (nolock)on P.cd_pes=HOU.cd_cliente and Tipo='C'
					Left Join vwFaturasValidas FAt with (nolock)on fat.num_proc=cc.Num_Proc_HIA and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.DC_HIA=fat.dc    
					Left join vwAXDocs AX with (nolock)on CC.Num_Proc_HIA = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.DC_HIA = ax.dc				
					Left join vwSolPgtoCtaCteAprovadas S with (nolock)on CC.Num_Proc_HIA = S.Num_proc  and CC.cd_tp_tx = S.Cd_Tp_Tx and cc.DC_HIA = S.dc
					--left join Base_Nota_Fiscal BA  with (nolock)on BA.Nota_Fiscal = CC.Num_NF_HIA and BA.Ref_Acesso =CC.Ref_Acesso_NF_HIA
					--left join vwFaturasValidasArg FARG With(nolock) on FARG.Numero = CC.Num_NF_HIA and FARG.Ref_Accesso_Arg =CC.Ref_Acesso_NF_HIA
					left join vwFaturasValidasArg FARG With(nolock) on CC.Num_Proc_HIA= FARG.Num_Proc and CC.cd_tp_tx = FARG.cd_tp_tx and CC.DC_HIA = FARG.DC
					
					join [vwCliente_Alerta] V with(nolock) on V.num_proc = CC.Num_proc_hia
					join Campo_Processo CP  with(nolock) on CP.Num_Proc = CC.Num_proc_hia and Id_Campo = 143
					
				WHERE 
					CXA.Num_Lcto is null and 
					CC.Num_Proc_HIA = @Processo 
					and Fat.num_proc is null --and F.FatCod is null
					and Desp_Org_HIA='N' 
					and desat_tx='N'
					and id_ax is null
					and S.ID is null
					and TT.Ref_Ctb_Tx <> 'ADT'

/* Antonio 26/01/2023   -  100-376296 –TRANSPORTATION - Faturamento antecipado 					
					and 
					(
						(LEFT(CC.Num_proc_hia,1) = 'E' and V.ATD is not null and CP.Campo_Dados in (2,3))
						or	
						(CP.Campo_Dados =1)
						or
						(LEFT(CC.Num_proc_hia,1) = 'I' and V.ATA is not null and CP.Campo_Dados in (2,3))
					)
*/
					--and V.Master = 'JOB'
				
			UNION ALL
			
				SELECT 
					distinct cc.cd_tp_moeda Moeda,
					(case When
							CC.Num_NF_HIA is not NULL
						Then 
							--CC.Par_NF_HIA 
							FARG.Paridade
						else 						
					--dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Paridade,
					(case when LEFT(CC.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM')
						else 
					(case when LEFT(CC.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA')
						else 
					(case when LEFT(CC.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM')
						else 
					(case when LEFT(CC.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')					
						else
							dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') 
					end)end)end)end)end)Paridade,					
					TT.Nome_tp_tx,
					
					--Vlr_Org_HIA*dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Valor,
					(case when LEFT(CC.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM') * Vlr_Org_HIA 
						else 
					(case when LEFT(CC.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA') * Vlr_Org_HIA 
						else 
					(case when LEFT(CC.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') * Vlr_Org_HIA 
						else 
					(case when LEFT(CC.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')	* Vlr_Org_HIA 				
						else
							dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC')  * Vlr_Org_HIA 
					end)end)end)end)Valor,
					
					CC.cd_tp_tx, CC.Cd_Cred_Dev_HIA Cd_Pes,cc.DC_HIA DC 
					,CC.Num_NF_HIA NF, CC.Ref_Acesso_NF_HIA [Site],
					Repasse_TX,
					isnull(FARG.Dt_Fatura,GETDATE()) Emissao
					,fat.FatVendorInvoiceNumber --Alessandra 19/05/2021 - AX10
				FROM 
					vwcta_Cte CC with (nolock)
					left Join Tipo_Taxa TT with (nolock)on CC.cd_tp_tx = TT.cd_tp_tx
					Join vwCliente HOU  with (nolock)on HOU.num_proc = CC.Num_Proc_HIA and HOU.cd_cliente = cc.Cd_Cred_Dev_HIA
					Left join vwCXAS CXA with (nolock)on	CC.Num_Proc_HIA	= CXA.Num_Proc_HIA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.DC_HIA = CXA.DC_HIA and num_lcto <> 'PROVISÓRIO'
					Join Pessoa_ATL_AX P with (nolock)on P.cd_pes=HOU.cd_cliente and Tipo='C'
					Left Join vwFaturasValidas FAt with (nolock)on fat.num_proc=cc.Num_Proc_HIA and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.DC_HIA=fat.dc    
					Left join vwAXDocs AX with (nolock)on CC.Num_Proc_HIA = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.DC_HIA = ax.dc				
					Left join vwSolPgtoCtaCteAprovadas S with (nolock)on CC.Num_Proc_HIA = S.Num_proc  and CC.cd_tp_tx = S.Cd_Tp_Tx and cc.DC_HIA = S.dc
					--left join Base_Nota_Fiscal BA  with (nolock)on BA.Nota_Fiscal = CC.Num_NF_HIA and BA.Ref_Acesso =CC.Ref_Acesso_NF_HIA
					--left join vwFaturasValidasArg FARG With(nolock) on FARG.Numero = CC.Num_NF_HIA and FARG.Ref_Accesso_Arg =CC.Ref_Acesso_NF_HIA
					left join vwFaturasValidasArg FARG With(nolock) on CC.Num_Proc_HIA= FARG.Num_Proc and CC.cd_tp_tx = FARG.cd_tp_tx and CC.DC_HIA = FARG.DC
					
					join [vwCliente_Alerta] V with(nolock) on V.Master = CC.Num_proc_hia 
					join Campo_Processo CP  with(nolock) on CP.Num_Proc = V.Num_proc and Id_Campo = 143
					
				WHERE 
					CXA.Num_Lcto is null and 
					CC.Num_Proc_HIA = @Processo 
					and Fat.num_proc is null --and F.FatCod is null
					and Desp_Org_HIA='N' 
					and desat_tx='N'
					and id_ax is null
					and S.ID is null
					and TT.Ref_Ctb_Tx <> 'ADT'

/* Antonio 26/01/2023   -  100-376296 –TRANSPORTATION - Faturamento antecipado 					
					and 
					(
						(LEFT(CC.Num_proc_hia,1) = 'E' and V.ATD is not null and CP.Campo_Dados in (2,3))
						or	
						(CP.Campo_Dados =1)
						or
						(LEFT(CC.Num_proc_hia,1) = 'I' and V.ATA is not null and CP.Campo_Dados in (2,3))
					)

*/			
		END
		
ELSE
	
		BEGIN
			Insert @TempTaxas
				SELECT 
					distinct cc.cd_tp_moeda Moeda,
	--				1 Paridade,
					(case When
						CC.Num_NF_HIA is not NULL and CC.Ref_Acesso_NF_HIA <> 'P'
					Then 
						--CC.Par_NF_HIA 
						FARG.Paridade
					else 
					--	dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') end ) Paridade,
						(case when LEFT(CC.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM')
							else 
						(case when LEFT(CC.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA')
							else 
						(case when LEFT(CC.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM')
							else 
						(case when LEFT(CC.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')					
							else
							dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') 
					end)end)end)end)end)Paridade,					 
					TT.Nome_tp_tx,Vlr_Org_HIA Valor, CC.cd_tp_tx, CC.Cd_Cred_Dev_HIA Cd_Pes,cc.DC_HIA DC 
					,CC.Num_NF_HIA NF, CC.Ref_Acesso_NF_HIA [Site]
					,Repasse_TX ,
					isnull(FARG.Dt_Fatura,GETDATE()) Emissao
					,fat.FatVendorInvoiceNumber --Alessandra 19/05/2021 - AX10
				FROM vwcta_Cte CC With(nolock)
					left Join Tipo_Taxa TT  With(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
					Left join vwCXAS CXA With(nolock) on	CC.Num_Proc_HIA	= CXA.Num_Proc_HIA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.DC_HIA = CXA.DC_HIA and num_lcto <> 'PROVISÓRIO'
					Left Join vwFaturasValidas FAt With(nolock) on fat.num_proc=cc.Num_Proc_HIA and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.DC_HIA=fat.dc
					Left join vwAXDocs AX With(nolock) on CC.Num_Proc_HIA = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.DC_HIA = ax.dc
					Join Pessoa_ATL_AX P With(nolock) on P.cd_pes=@cdPes and Tipo='C'
					Left join vwSolPgtoCtaCteAprovadas S With(nolock) on CC.Num_Proc_HIA = S.Num_proc  and CC.cd_tp_tx = S.Cd_Tp_Tx and cc.DC_HIA = S.dc
					--left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CC.Num_NF_HIA and BA.Ref_Acesso =CC.Ref_Acesso_NF_HIA
					--left join vwFaturasValidasArg FARG With(nolock) on FARG.Numero = CC.Num_NF_HIA and FARG.Ref_Accesso_Arg =CC.Ref_Acesso_NF_HIA
					left join vwFaturasValidasArg FARG With(nolock) on CC.Num_Proc_HIA= FARG.Num_Proc and CC.cd_tp_tx = FARG.cd_tp_tx and CC.DC_HIA = FARG.DC
					
					join [vwCliente_Alerta] V with(nolock) on V.num_proc = CC.Num_proc_hia
					join Campo_Processo CP  with(nolock) on CP.Num_Proc = CC.Num_proc_hia and Id_Campo = 143
					
				WHERE 
					CXA.Num_Lcto is null and 
					CC.Num_Proc_HIA = @Processo and Fat.num_proc is null 
					and CC.Cd_Cred_Dev_HIA = @cdPes
					and Desp_Org_HIA='N' 
					and desat_tx='N'
					and id_ax is null
					and S.ID is null
					and TT.Ref_Ctb_Tx <> 'ADT'

/* Antonio 26/01/2023   -  100-376296 –TRANSPORTATION - Faturamento antecipado 					
					and 
					(
						(LEFT(CC.Num_proc_hia,1) = 'E' and V.ATD is not null and CP.Campo_Dados in (2,3))
						or	
						(CP.Campo_Dados =1)
						or
						(LEFT(CC.Num_proc_hia,1) = 'I' and V.ATA is not null and CP.Campo_Dados in (2,3))
					)
*/
					--and V.Master = 'JOB'
					
			UNION ALL
			
				SELECT 
					distinct cc.cd_tp_moeda Moeda,
	--				1 Paridade,
					(case When
						CC.Num_NF_HIA is not NULL and CC.Ref_Acesso_NF_HIA <> 'P'
					Then 
						--CC.Par_NF_HIA 
						FARG.Paridade
					else 
					--	dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') end ) Paridade,
						(case when LEFT(CC.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM')
							else 
						(case when LEFT(CC.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA')
							else 
						(case when LEFT(CC.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM')
							else 
						(case when LEFT(CC.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')					
							else
							dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') 
					end)end)end)end)end)Paridade,					 
					TT.Nome_tp_tx,Vlr_Org_HIA Valor, CC.cd_tp_tx, CC.Cd_Cred_Dev_HIA Cd_Pes,cc.DC_HIA DC 
					,CC.Num_NF_HIA NF, CC.Ref_Acesso_NF_HIA [Site]
					,Repasse_TX ,
					isnull(FARG.Dt_Fatura,GETDATE()) Emissao
					,fat.FatVendorInvoiceNumber --Alessandra 19/05/2021 - AX10
				FROM vwcta_Cte CC With(nolock)
					left Join Tipo_Taxa TT  With(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
					Left join vwCXAS CXA With(nolock) on	CC.Num_Proc_HIA	= CXA.Num_Proc_HIA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.DC_HIA = CXA.DC_HIA and num_lcto <> 'PROVISÓRIO'
					Left Join vwFaturasValidas FAt With(nolock) on fat.num_proc=cc.Num_Proc_HIA and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.DC_HIA=fat.dc
					Left join vwAXDocs AX With(nolock) on CC.Num_Proc_HIA = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.DC_HIA = ax.dc
					Join Pessoa_ATL_AX P With(nolock) on P.cd_pes=@cdPes and Tipo='C'
					Left join vwSolPgtoCtaCteAprovadas S With(nolock) on CC.Num_Proc_HIA = S.Num_proc  and CC.cd_tp_tx = S.Cd_Tp_Tx and cc.DC_HIA = S.dc
					--left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CC.Num_NF_HIA and BA.Ref_Acesso =CC.Ref_Acesso_NF_HIA
					--left join vwFaturasValidasArg FARG With(nolock) on FARG.Numero = CC.Num_NF_HIA and FARG.Ref_Accesso_Arg =CC.Ref_Acesso_NF_HIA
					left join vwFaturasValidasArg FARG With(nolock) on CC.Num_Proc_HIA= FARG.Num_Proc and CC.cd_tp_tx = FARG.cd_tp_tx and CC.DC_HIA = FARG.DC
					
					join [vwCliente_Alerta] V with(nolock) on V.Master = CC.Num_proc_hia 
					join Campo_Processo CP  with(nolock) on CP.Num_Proc = V.Num_proc and Id_Campo = 143
					
				WHERE 
					CXA.Num_Lcto is null and 
					CC.Num_Proc_HIA = @Processo and Fat.num_proc is null 
					and CC.Cd_Cred_Dev_HIA = @cdPes
					and Desp_Org_HIA='N' 
					and desat_tx='N'
					and id_ax is null
					and S.ID is null
					and TT.Ref_Ctb_Tx <> 'ADT'

/* Antonio 26/01/2023   -  100-376296 –TRANSPORTATION - Faturamento antecipado 					
					and 
					(
						(LEFT(CC.Num_proc_hia,1) = 'E' and V.ATD is not null and CP.Campo_Dados in (2,3))
						or	
						(CP.Campo_Dados =1)
						or
						(LEFT(CC.Num_proc_hia,1) = 'I' and V.ATA is not null and CP.Campo_Dados in (2,3))
					)
*/				
					
			END

update 
	T  
set 
	T.Paridade=T1.Paridade
from 
	@TempTaxas as T
JOIN
	@TempTaxas  as T1
	on T.Moeda = T1.Moeda and T1.NF is not NULL
--select Moeda,Paridade from @TempTaxas as T2 where NF is not NULL
--where NF is NULL
	
select * from @TempTaxas where month(Emissao) = MONTH(getdate()) 

/*
Inicio 
original de produção Antonio 26-01-2023 - 100-376296 –TRANSPORTATION - Faturamento antecipado 

--spTaxasBDPInvoice_Sel 'IASTL201308001BR', 'STEELCASE'
--spTaxasBDPInvoice_sel 'IAATL201307051BR', 'PPG INDUSTRIA - 1642'
--spTaxasBDPInvoiceErbson_Sel'EMATL201301031BR', 'BDPT'
--incluido o and desat_tx='N' 30-7-2013 cadu
--incluido no case de nf pra nao pega os casos q são: CC.ref_acesso_nf <> 'P'
--spTaxasBDPInvoice_Sel 'EAVCP201301002', 'FEDEX'
--incluido pra não trazer os casos q tem id_ax - cadu 07-04-2014
--incluido verificar a vwSolPgtoCtaCteAprovadas - cadu 07/10/2014
--incluido verificar a data de emissao da nf, pra so trazer o que for do mes  - cadu 30-07-2015
--incluido ser pela vwFaturas - cadu 15-09-2015
--nao trazer adiantamentos - cadu 15-09-2015
--usar view - 15/09/2015
--incluido ver a paridade do fatura Arg det - erbson/cadu - 23/09/15
--incluido ver a paridade do fatura Arg det  num proc X DC x CD_tp_tx - erbson/cadu - 23/10/15

--26-10-2016 - incluido p trazer o master
--spTaxasBDPInvoice_Sel 'EAGRU201610007', 'ABSA - 1691C'

ALTER procedure [dbo].[spTaxasBDPInvoice_Sel]-- spTaxasBDPInvoice_Sel 'EAGRU201610007', 'ABSA - 1691C'
(
	@Processo varchar(16),
	@Pessoa varchar(50)
)

AS

/*
	Anderson Oliveira - 13/12/2013 - Incluido: relação com tabela Pessoa_ATL_TX
	Por definição do projeto AX, é necessário ter um cliente no AX para emissão da Fatura
*/

SET NOCOUNT ON
	Declare @CdPes varchar(10)
	
	Declare @TempTaxas Table
	(
		Moeda		varchar(3),
		Paridade	float,
		Nome_tp_tx	varchar(50),
		Valor		decimal(10,2),
		cd_tp_tx	varchar(10),
		Cd_Pes		varchar(10),
		DC			varchar(1),
		NF			varchar(12),
		[Site]		varchar(1),
		Repasse_TX	varchar(1),
		Emissao		Datetime	
		,FatVendorInvoiceNumber	varchar(17) --Alessandra 19/05/2021 - AX10
	)
		
	If @Pessoa <> '' 
		begin
				set @cdPes = (Select cd_pes from pessoa where apelido = @Pessoa)
		end
	
	If @Pessoa = ''
		Begin
			Insert @TempTaxas
				SELECT 
					distinct cc.cd_tp_moeda Moeda,
					(case When
							CC.Num_NF_HIA is not NULL
						Then 
							--CC.Par_NF_HIA 
							FARG.Paridade
						else 						
					--dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Paridade,
					(case when LEFT(CC.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM')
						else 
					(case when LEFT(CC.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA')
						else 
					(case when LEFT(CC.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM')
						else 
					(case when LEFT(CC.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')					
						else
							dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') 
					end)end)end)end)end)Paridade,					
					TT.Nome_tp_tx,
					
					--Vlr_Org_HIA*dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Valor,
					(case when LEFT(CC.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM') * Vlr_Org_HIA 
						else 
					(case when LEFT(CC.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA') * Vlr_Org_HIA 
						else 
					(case when LEFT(CC.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') * Vlr_Org_HIA 
						else 
					(case when LEFT(CC.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')	* Vlr_Org_HIA 				
						else
							dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC')  * Vlr_Org_HIA 
					end)end)end)end)Valor,
					
					CC.cd_tp_tx, CC.Cd_Cred_Dev_HIA Cd_Pes,cc.DC_HIA DC 
					,CC.Num_NF_HIA NF, CC.Ref_Acesso_NF_HIA [Site],
					Repasse_TX,
					isnull(FARG.Dt_Fatura,GETDATE()) Emissao
					,fat.FatVendorInvoiceNumber --Alessandra 19/05/2021 - AX10
				FROM 
					vwcta_Cte CC with (nolock)
					left Join Tipo_Taxa TT with (nolock)on CC.cd_tp_tx = TT.cd_tp_tx
					Join vwCliente HOU  with (nolock)on HOU.num_proc = CC.Num_Proc_HIA and HOU.cd_cliente = cc.Cd_Cred_Dev_HIA
					Left join vwCXAS CXA with (nolock)on	CC.Num_Proc_HIA	= CXA.Num_Proc_HIA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.DC_HIA = CXA.DC_HIA and num_lcto <> 'PROVISÓRIO'
					Join Pessoa_ATL_AX P with (nolock)on P.cd_pes=HOU.cd_cliente and Tipo='C'
					Left Join vwFaturasValidas FAt with (nolock)on fat.num_proc=cc.Num_Proc_HIA and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.DC_HIA=fat.dc    
					Left join vwAXDocs AX with (nolock)on CC.Num_Proc_HIA = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.DC_HIA = ax.dc				
					Left join vwSolPgtoCtaCteAprovadas S with (nolock)on CC.Num_Proc_HIA = S.Num_proc  and CC.cd_tp_tx = S.Cd_Tp_Tx and cc.DC_HIA = S.dc
					--left join Base_Nota_Fiscal BA  with (nolock)on BA.Nota_Fiscal = CC.Num_NF_HIA and BA.Ref_Acesso =CC.Ref_Acesso_NF_HIA
					--left join vwFaturasValidasArg FARG With(nolock) on FARG.Numero = CC.Num_NF_HIA and FARG.Ref_Accesso_Arg =CC.Ref_Acesso_NF_HIA
					left join vwFaturasValidasArg FARG With(nolock) on CC.Num_Proc_HIA= FARG.Num_Proc and CC.cd_tp_tx = FARG.cd_tp_tx and CC.DC_HIA = FARG.DC
					
					join [vwCliente_Alerta] V with(nolock) on V.num_proc = CC.Num_proc_hia
					join Campo_Processo CP  with(nolock) on CP.Num_Proc = CC.Num_proc_hia and Id_Campo = 143
					
				WHERE 
					CXA.Num_Lcto is null and 
					CC.Num_Proc_HIA = @Processo 
					and Fat.num_proc is null --and F.FatCod is null
					and Desp_Org_HIA='N' 
					and desat_tx='N'
					and id_ax is null
					and S.ID is null
					and TT.Ref_Ctb_Tx <> 'ADT'
					
					and 
					(
						(LEFT(CC.Num_proc_hia,1) = 'E' and V.ATD is not null and CP.Campo_Dados in (2,3))
						or	
						(CP.Campo_Dados =1)
						or
						(LEFT(CC.Num_proc_hia,1) = 'I' and V.ATA is not null and CP.Campo_Dados in (2,3))
					)
					--and V.Master = 'JOB'
				
			UNION ALL
			
				SELECT 
					distinct cc.cd_tp_moeda Moeda,
					(case When
							CC.Num_NF_HIA is not NULL
						Then 
							--CC.Par_NF_HIA 
							FARG.Paridade
						else 						
					--dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Paridade,
					(case when LEFT(CC.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM')
						else 
					(case when LEFT(CC.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA')
						else 
					(case when LEFT(CC.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM')
						else 
					(case when LEFT(CC.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')					
						else
							dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') 
					end)end)end)end)end)Paridade,					
					TT.Nome_tp_tx,
					
					--Vlr_Org_HIA*dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Valor,
					(case when LEFT(CC.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM') * Vlr_Org_HIA 
						else 
					(case when LEFT(CC.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA') * Vlr_Org_HIA 
						else 
					(case when LEFT(CC.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') * Vlr_Org_HIA 
						else 
					(case when LEFT(CC.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')	* Vlr_Org_HIA 				
						else
							dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC')  * Vlr_Org_HIA 
					end)end)end)end)Valor,
					
					CC.cd_tp_tx, CC.Cd_Cred_Dev_HIA Cd_Pes,cc.DC_HIA DC 
					,CC.Num_NF_HIA NF, CC.Ref_Acesso_NF_HIA [Site],
					Repasse_TX,
					isnull(FARG.Dt_Fatura,GETDATE()) Emissao
					,fat.FatVendorInvoiceNumber --Alessandra 19/05/2021 - AX10
				FROM 
					vwcta_Cte CC with (nolock)
					left Join Tipo_Taxa TT with (nolock)on CC.cd_tp_tx = TT.cd_tp_tx
					Join vwCliente HOU  with (nolock)on HOU.num_proc = CC.Num_Proc_HIA and HOU.cd_cliente = cc.Cd_Cred_Dev_HIA
					Left join vwCXAS CXA with (nolock)on	CC.Num_Proc_HIA	= CXA.Num_Proc_HIA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.DC_HIA = CXA.DC_HIA and num_lcto <> 'PROVISÓRIO'
					Join Pessoa_ATL_AX P with (nolock)on P.cd_pes=HOU.cd_cliente and Tipo='C'
					Left Join vwFaturasValidas FAt with (nolock)on fat.num_proc=cc.Num_Proc_HIA and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.DC_HIA=fat.dc    
					Left join vwAXDocs AX with (nolock)on CC.Num_Proc_HIA = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.DC_HIA = ax.dc				
					Left join vwSolPgtoCtaCteAprovadas S with (nolock)on CC.Num_Proc_HIA = S.Num_proc  and CC.cd_tp_tx = S.Cd_Tp_Tx and cc.DC_HIA = S.dc
					--left join Base_Nota_Fiscal BA  with (nolock)on BA.Nota_Fiscal = CC.Num_NF_HIA and BA.Ref_Acesso =CC.Ref_Acesso_NF_HIA
					--left join vwFaturasValidasArg FARG With(nolock) on FARG.Numero = CC.Num_NF_HIA and FARG.Ref_Accesso_Arg =CC.Ref_Acesso_NF_HIA
					left join vwFaturasValidasArg FARG With(nolock) on CC.Num_Proc_HIA= FARG.Num_Proc and CC.cd_tp_tx = FARG.cd_tp_tx and CC.DC_HIA = FARG.DC
					
					join [vwCliente_Alerta] V with(nolock) on V.Master = CC.Num_proc_hia 
					join Campo_Processo CP  with(nolock) on CP.Num_Proc = V.Num_proc and Id_Campo = 143
					
				WHERE 
					CXA.Num_Lcto is null and 
					CC.Num_Proc_HIA = @Processo 
					and Fat.num_proc is null --and F.FatCod is null
					and Desp_Org_HIA='N' 
					and desat_tx='N'
					and id_ax is null
					and S.ID is null
					and TT.Ref_Ctb_Tx <> 'ADT'
					
					and 
					(
						(LEFT(CC.Num_proc_hia,1) = 'E' and V.ATD is not null and CP.Campo_Dados in (2,3))
						or	
						(CP.Campo_Dados =1)
						or
						(LEFT(CC.Num_proc_hia,1) = 'I' and V.ATA is not null and CP.Campo_Dados in (2,3))
					)
			
		END
		
ELSE
	
		BEGIN
			Insert @TempTaxas
				SELECT 
					distinct cc.cd_tp_moeda Moeda,
	--				1 Paridade,
					(case When
						CC.Num_NF_HIA is not NULL and CC.Ref_Acesso_NF_HIA <> 'P'
					Then 
						--CC.Par_NF_HIA 
						FARG.Paridade
					else 
					--	dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') end ) Paridade,
						(case when LEFT(CC.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM')
							else 
						(case when LEFT(CC.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA')
							else 
						(case when LEFT(CC.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM')
							else 
						(case when LEFT(CC.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')					
							else
							dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') 
					end)end)end)end)end)Paridade,					 
					TT.Nome_tp_tx,Vlr_Org_HIA Valor, CC.cd_tp_tx, CC.Cd_Cred_Dev_HIA Cd_Pes,cc.DC_HIA DC 
					,CC.Num_NF_HIA NF, CC.Ref_Acesso_NF_HIA [Site]
					,Repasse_TX ,
					isnull(FARG.Dt_Fatura,GETDATE()) Emissao
					,fat.FatVendorInvoiceNumber --Alessandra 19/05/2021 - AX10
				FROM vwcta_Cte CC With(nolock)
					left Join Tipo_Taxa TT  With(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
					Left join vwCXAS CXA With(nolock) on	CC.Num_Proc_HIA	= CXA.Num_Proc_HIA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.DC_HIA = CXA.DC_HIA and num_lcto <> 'PROVISÓRIO'
					Left Join vwFaturasValidas FAt With(nolock) on fat.num_proc=cc.Num_Proc_HIA and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.DC_HIA=fat.dc
					Left join vwAXDocs AX With(nolock) on CC.Num_Proc_HIA = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.DC_HIA = ax.dc
					Join Pessoa_ATL_AX P With(nolock) on P.cd_pes=@cdPes and Tipo='C'
					Left join vwSolPgtoCtaCteAprovadas S With(nolock) on CC.Num_Proc_HIA = S.Num_proc  and CC.cd_tp_tx = S.Cd_Tp_Tx and cc.DC_HIA = S.dc
					--left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CC.Num_NF_HIA and BA.Ref_Acesso =CC.Ref_Acesso_NF_HIA
					--left join vwFaturasValidasArg FARG With(nolock) on FARG.Numero = CC.Num_NF_HIA and FARG.Ref_Accesso_Arg =CC.Ref_Acesso_NF_HIA
					left join vwFaturasValidasArg FARG With(nolock) on CC.Num_Proc_HIA= FARG.Num_Proc and CC.cd_tp_tx = FARG.cd_tp_tx and CC.DC_HIA = FARG.DC
					
					join [vwCliente_Alerta] V with(nolock) on V.num_proc = CC.Num_proc_hia
					join Campo_Processo CP  with(nolock) on CP.Num_Proc = CC.Num_proc_hia and Id_Campo = 143
					
				WHERE 
					CXA.Num_Lcto is null and 
					CC.Num_Proc_HIA = @Processo and Fat.num_proc is null 
					and CC.Cd_Cred_Dev_HIA = @cdPes
					and Desp_Org_HIA='N' 
					and desat_tx='N'
					and id_ax is null
					and S.ID is null
					and TT.Ref_Ctb_Tx <> 'ADT'
					
					and 
					(
						(LEFT(CC.Num_proc_hia,1) = 'E' and V.ATD is not null and CP.Campo_Dados in (2,3))
						or	
						(CP.Campo_Dados =1)
						or
						(LEFT(CC.Num_proc_hia,1) = 'I' and V.ATA is not null and CP.Campo_Dados in (2,3))
					)
					--and V.Master = 'JOB'
					
			UNION ALL
			
				SELECT 
					distinct cc.cd_tp_moeda Moeda,
	--				1 Paridade,
					(case When
						CC.Num_NF_HIA is not NULL and CC.Ref_Acesso_NF_HIA <> 'P'
					Then 
						--CC.Par_NF_HIA 
						FARG.Paridade
					else 
					--	dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') end ) Paridade,
						(case when LEFT(CC.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM')
							else 
						(case when LEFT(CC.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA')
							else 
						(case when LEFT(CC.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM')
							else 
						(case when LEFT(CC.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')					
							else
							dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') 
					end)end)end)end)end)Paridade,					 
					TT.Nome_tp_tx,Vlr_Org_HIA Valor, CC.cd_tp_tx, CC.Cd_Cred_Dev_HIA Cd_Pes,cc.DC_HIA DC 
					,CC.Num_NF_HIA NF, CC.Ref_Acesso_NF_HIA [Site]
					,Repasse_TX ,
					isnull(FARG.Dt_Fatura,GETDATE()) Emissao
					,fat.FatVendorInvoiceNumber --Alessandra 19/05/2021 - AX10
				FROM vwcta_Cte CC With(nolock)
					left Join Tipo_Taxa TT  With(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
					Left join vwCXAS CXA With(nolock) on	CC.Num_Proc_HIA	= CXA.Num_Proc_HIA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.DC_HIA = CXA.DC_HIA and num_lcto <> 'PROVISÓRIO'
					Left Join vwFaturasValidas FAt With(nolock) on fat.num_proc=cc.Num_Proc_HIA and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.DC_HIA=fat.dc
					Left join vwAXDocs AX With(nolock) on CC.Num_Proc_HIA = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.DC_HIA = ax.dc
					Join Pessoa_ATL_AX P With(nolock) on P.cd_pes=@cdPes and Tipo='C'
					Left join vwSolPgtoCtaCteAprovadas S With(nolock) on CC.Num_Proc_HIA = S.Num_proc  and CC.cd_tp_tx = S.Cd_Tp_Tx and cc.DC_HIA = S.dc
					--left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CC.Num_NF_HIA and BA.Ref_Acesso =CC.Ref_Acesso_NF_HIA
					--left join vwFaturasValidasArg FARG With(nolock) on FARG.Numero = CC.Num_NF_HIA and FARG.Ref_Accesso_Arg =CC.Ref_Acesso_NF_HIA
					left join vwFaturasValidasArg FARG With(nolock) on CC.Num_Proc_HIA= FARG.Num_Proc and CC.cd_tp_tx = FARG.cd_tp_tx and CC.DC_HIA = FARG.DC
					
					join [vwCliente_Alerta] V with(nolock) on V.Master = CC.Num_proc_hia 
					join Campo_Processo CP  with(nolock) on CP.Num_Proc = V.Num_proc and Id_Campo = 143
					
				WHERE 
					CXA.Num_Lcto is null and 
					CC.Num_Proc_HIA = @Processo and Fat.num_proc is null 
					and CC.Cd_Cred_Dev_HIA = @cdPes
					and Desp_Org_HIA='N' 
					and desat_tx='N'
					and id_ax is null
					and S.ID is null
					and TT.Ref_Ctb_Tx <> 'ADT'
					
					and 
					(
						(LEFT(CC.Num_proc_hia,1) = 'E' and V.ATD is not null and CP.Campo_Dados in (2,3))
						or	
						(CP.Campo_Dados =1)
						or
						(LEFT(CC.Num_proc_hia,1) = 'I' and V.ATA is not null and CP.Campo_Dados in (2,3))
					)
				
					
			END

update 
	T  
set 
	T.Paridade=T1.Paridade
from 
	@TempTaxas as T
JOIN
	@TempTaxas  as T1
	on T.Moeda = T1.Moeda and T1.NF is not NULL
--select Moeda,Paridade from @TempTaxas as T2 where NF is not NULL
--where NF is NULL
	
select * from @TempTaxas where month(Emissao) = MONTH(getdate()) 

------ fim ticket 100-376296 –TRANSPORTATION - Faturamento antecipado 


ALTER procedure [dbo].[spTaxasBDPInvoice_Sel]-- spTaxasBDPInvoice_Sel 'EMOXT201310068BR', 'OXITENO NORDESTE'
(
	@Processo varchar(16),
	@Pessoa varchar(50)
)

AS
/*
	Anderson Oliveira - 13/12/2013 - Incluido: relação com tabela Pessoa_ATL_TX
	Por definição do projeto AX, é necessário ter um cliente no AX para emissão da Fatura
*/

SET NOCOUNT ON
	Declare @CdPes varchar(10)
	
	Declare @TempTaxas Table
	(
		Moeda		varchar(3),
		Paridade	float,
		Nome_tp_tx	varchar(50),
		Valor		decimal(10,2),
		cd_tp_tx	varchar(10),
		Cd_Pes		varchar(10),
		DC			varchar(1),
		NF			varchar(12),
		[Site]		varchar(1),
		Repasse_TX	varchar(1),
		Emissao		Datetime	
	)
		
	If @Pessoa <> '' 
		begin
				set @cdPes = (Select cd_pes from pessoa where apelido = @Pessoa)
		end
	
	If @Pessoa = ''
		Begin
			Insert @TempTaxas
				SELECT 
					distinct cc.cd_tp_moeda Moeda,
					(case When
							CC.Num_NF_HIA is not NULL
						Then 
							--CC.Par_NF_HIA 
							FARG.Paridade
						else 						
					--dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Paridade,
					(case when LEFT(CC.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM')
						else 
					(case when LEFT(CC.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA')
						else 
					(case when LEFT(CC.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM')
						else 
					(case when LEFT(CC.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')					
						else
							dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') 
					end)end)end)end)end)Paridade,					
					TT.Nome_tp_tx,
					
					--Vlr_Org_HIA*dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Valor,
					(case when LEFT(CC.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM') * Vlr_Org_HIA 
						else 
					(case when LEFT(CC.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA') * Vlr_Org_HIA 
						else 
					(case when LEFT(CC.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') * Vlr_Org_HIA 
						else 
					(case when LEFT(CC.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')	* Vlr_Org_HIA 				
						else
							dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC')  * Vlr_Org_HIA 
					end)end)end)end)Valor,
					
					CC.cd_tp_tx, CC.Cd_Cred_Dev_HIA Cd_Pes,cc.DC_HIA DC 
					,CC.Num_NF_HIA NF, CC.Ref_Acesso_NF_HIA [Site],
					Repasse_TX,
					isnull(FARG.Dt_Fatura,GETDATE()) Emissao
				FROM 
					vwcta_Cte CC with (nolock)
					left Join Tipo_Taxa TT with (nolock)on CC.cd_tp_tx = TT.cd_tp_tx
					Join vwCliente HOU  with (nolock)on HOU.num_proc = CC.Num_Proc_HIA and HOU.cd_cliente = cc.Cd_Cred_Dev_HIA
					Left join vwCXAS CXA with (nolock)on	CC.Num_Proc_HIA	= CXA.Num_Proc_HIA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.DC_HIA = CXA.DC_HIA and num_lcto <> 'PROVISÓRIO'
					Join Pessoa_ATL_AX P with (nolock)on P.cd_pes=HOU.cd_cliente and Tipo='C'
					Left Join vwFaturasValidas FAt with (nolock)on fat.num_proc=cc.Num_Proc_HIA and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.DC_HIA=fat.dc    
					Left join vwAXDocs AX with (nolock)on CC.Num_Proc_HIA = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.DC_HIA = ax.dc				
					Left join vwSolPgtoCtaCteAprovadas S with (nolock)on CC.Num_Proc_HIA = S.Num_proc  and CC.cd_tp_tx = S.Cd_Tp_Tx and cc.DC_HIA = S.dc
					--left join Base_Nota_Fiscal BA  with (nolock)on BA.Nota_Fiscal = CC.Num_NF_HIA and BA.Ref_Acesso =CC.Ref_Acesso_NF_HIA
					--left join vwFaturasValidasArg FARG With(nolock) on FARG.Numero = CC.Num_NF_HIA and FARG.Ref_Accesso_Arg =CC.Ref_Acesso_NF_HIA
					left join vwFaturasValidasArg FARG With(nolock) on CC.Num_Proc_HIA= FARG.Num_Proc and CC.cd_tp_tx = FARG.cd_tp_tx and CC.DC_HIA = FARG.DC
				WHERE 
					CXA.Num_Lcto is null and 
					CC.Num_Proc_HIA = @Processo 
					and Fat.num_proc is null --and F.FatCod is null
					and Desp_Org_HIA='N' 
					and desat_tx='N'
					and id_ax is null
					and S.ID is null
					and TT.Ref_Ctb_Tx <> 'ADT'
		END
		
ELSE
	
		BEGIN
			Insert @TempTaxas
				SELECT 
					distinct cc.cd_tp_moeda Moeda,
	--				1 Paridade,
					(case When
						CC.Num_NF_HIA is not NULL and CC.Ref_Acesso_NF_HIA <> 'P'
					Then 
						--CC.Par_NF_HIA 
						FARG.Paridade
					else 
					--	dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') end ) Paridade,
						(case when LEFT(CC.Num_Proc_HIA,2) = 'EM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXM')
							else 
						(case when LEFT(CC.Num_Proc_HIA,2) = 'EA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'EXA')
							else 
						(case when LEFT(CC.Num_Proc_HIA,2) = 'IM' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM')
							else 
						(case when LEFT(CC.Num_Proc_HIA,2)= 'IA' then dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMA')					
							else
							dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') 
					end)end)end)end)end)Paridade,					 
					TT.Nome_tp_tx,Vlr_Org_HIA Valor, CC.cd_tp_tx, CC.Cd_Cred_Dev_HIA Cd_Pes,cc.DC_HIA DC 
					,CC.Num_NF_HIA NF, CC.Ref_Acesso_NF_HIA [Site]
					,Repasse_TX ,
					isnull(FARG.Dt_Fatura,GETDATE()) Emissao
				FROM vwcta_Cte CC With(nolock)
					left Join Tipo_Taxa TT  With(nolock) on CC.cd_tp_tx = TT.cd_tp_tx
					Left join vwCXAS CXA With(nolock) on	CC.Num_Proc_HIA	= CXA.Num_Proc_HIA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.DC_HIA = CXA.DC_HIA and num_lcto <> 'PROVISÓRIO'
					Left Join vwFaturasValidas FAt With(nolock) on fat.num_proc=cc.Num_Proc_HIA and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.DC_HIA=fat.dc
					Left join vwAXDocs AX With(nolock) on CC.Num_Proc_HIA = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.DC_HIA = ax.dc
					Join Pessoa_ATL_AX P With(nolock) on P.cd_pes=@cdPes and Tipo='C'
					Left join vwSolPgtoCtaCteAprovadas S With(nolock) on CC.Num_Proc_HIA = S.Num_proc  and CC.cd_tp_tx = S.Cd_Tp_Tx and cc.DC_HIA = S.dc
					--left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CC.Num_NF_HIA and BA.Ref_Acesso =CC.Ref_Acesso_NF_HIA
					--left join vwFaturasValidasArg FARG With(nolock) on FARG.Numero = CC.Num_NF_HIA and FARG.Ref_Accesso_Arg =CC.Ref_Acesso_NF_HIA
					left join vwFaturasValidasArg FARG With(nolock) on CC.Num_Proc_HIA= FARG.Num_Proc and CC.cd_tp_tx = FARG.cd_tp_tx and CC.DC_HIA = FARG.DC
				WHERE 
					CXA.Num_Lcto is null and 
					CC.Num_Proc_HIA = @Processo and Fat.num_proc is null 
					and CC.Cd_Cred_Dev_HIA = @cdPes
					and Desp_Org_HIA='N' 
					and desat_tx='N'
					and id_ax is null
					and S.ID is null
					and TT.Ref_Ctb_Tx <> 'ADT'
			END

update 
	T  
set 
	T.Paridade=T1.Paridade
from 
	@TempTaxas as T
JOIN
	@TempTaxas  as T1
	on T.Moeda = T1.Moeda and T1.NF is not NULL
--select Moeda,Paridade from @TempTaxas as T2 where NF is not NULL
--where NF is NULL
	
select * from @TempTaxas where month(Emissao) = MONTH(getdate()) 



/* Stored Antiga
ALTER procedure [dbo].[spTaxasBDPInvoice_Sel]-- spTaxasBDPInvoice_Sel 'EMOXT201310068BR', 'OXITENO NORDESTE'
(
	@Processo varchar(16),
	@Pessoa varchar(50)
)

AS
/*
	Anderson Oliveira - 13/12/2013 - Incluido: relação com tabela Pessoa_ATL_TX
	Por definição do projeto AX, é necessário ter um cliente no AX para emissão da Fatura

*/


SET NOCOUNT ON
	Declare @CdPes varchar(10)
	Declare @Fatura Table
		(
			Num_proc	varchar(16),
			Cd_tp_Tx	Varchar(3),
			DC			Varchar(1)
			
		)
	Declare @TempTaxas Table
	(
		Moeda		varchar(3),
		Paridade	float,
		Nome_tp_tx	varchar(50),
		Valor		decimal(10,2),
		cd_tp_tx	varchar(10),
		Cd_Pes		varchar(10),
		DC			varchar(1),
		NF			varchar(12),
		[Site]		varchar(1),
		Repasse_TX	varchar(1),
		Emissao			Datetime	
	)
	
	--	Declare @TempTaxas1 Table
	--(
	--	Moeda		varchar(3),
	--	Paridade	varchar(10),
	--	Nome_tp_tx	varchar(50),
	--	Valor		varchar(10),
	--	cd_tp_tx	varchar(10),
	--	Cd_Pes		varchar(10),
	--	DC			varchar(1),
	--	NF			varchar(12),
	--	[Site]		varchar(1),
	--	Repasse_TX	varchar(1)
	--)
	Begin 		
		Insert @Fatura	
		Select left(i.fatcod,16),cd_tp_Tx,dc from item_fat I
		Join Fatura F on F.fatcod=i.fatcod 
		where
			left(f.fatcod,16)=@Processo and fatstatus =1
	End		
	If @Pessoa <> '' 
		begin
				set @cdPes = (Select cd_pes from pessoa where apelido = @Pessoa)
		end
	
	If @Pessoa = ''
		Begin
			Insert @TempTaxas
			SELECT 
				distinct cc.cd_tp_moeda Moeda,dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Paridade,TT.Nome_tp_tx,vlr_org_HEM*dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Valor, CC.cd_tp_tx, CC.cd_cred_dev_hem Cd_Pes,cc.dc_hem DC 
				,CC.num_nf_hem NF, CC.ref_acesso_nf_hem [Site]
				,Repasse_TX ,
				isnull(BA.Emissao,GETDATE()) Emissao
			FROM 
				Cta_Cte_Hou_Exp_Mar CC
				left Join Tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
				Join House_Exp_Mar HOU with(nolock) on HOU.num_proc_HEM = CC.num_proc_HEM and HOU.cd_export_hem = cc.cd_cred_dev_hem
				Left join Caixa_Hou_Exp_Mar CXA on	CC.num_proc_HEM	= CXA.num_proc_HEM and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HEM = CXA.dc_HEM and num_lcto <> 'PROVISÓRIO'
--				Left Join item_Fat FAT on CC.num_proc_HEM = FAT.num_proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hem = FAT.dc
--				Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1 
				Join Pessoa_ATL_AX P on P.cd_pes=HOU.cd_export_hem and Tipo='C'
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_hem and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hem=fat.dc    
				Left join vwAXDocs AX on CC.Num_proc_hem = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_hem = ax.dc
				
				Left join vwSolPgtoCtaCteAprovadas S on CC.Num_proc_hem = S.Num_proc  and CC.cd_tp_tx = S.Cd_Tp_Tx and cc.dc_hem = S.dc
				left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CC.Num_NF_HEM and BA.Ref_Acesso =CC.Ref_Acesso_NF_HEM
			WHERE 
				CXA.Num_Lcto is null and 
				CC.Num_Proc_HEM = @Processo and Fat.num_proc is null --and F.FatCod is null
				and desp_dst_hem='N' and desat_tx='N'
				and id_ax is null
				and S.ID is null				
				

		union all

			SELECT 
				distinct cc.cd_tp_moeda,dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Paridade,TT.Nome_tp_tx,vlr_org_HEA*dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Valor, CC.cd_tp_tx, CC.cd_cred_dev_hea Cd_Pes,cc.dc_hea 
				,CC.num_nf_hea NF, CC.ref_acesso_nf_hea [Site]
				,Repasse_TX,
				isnull(BA.Emissao,GETDATE()) Emissao			
			FROM 
				Cta_Cte_Hou_Exp_Aer CC
				left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
				Join House_Exp_Aer HOU with(nolock) on HOU.num_proc_HEA = CC.num_proc_HEA and HOU.cd_export_hea = cc.cd_cred_dev_hea
				Left join Caixa_Hou_Exp_Aer CXA on	CC.num_proc_HEA	= CXA.num_proc_HEA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HEA = CXA.dc_HEA and num_lcto <> 'PROVISÓRIO'
	--			Left Join fatura_chb_item FAT on CC.num_proc_HEA = left(FAT.Fatura_CC,16) and CC.cd_tp_tx = FAT.cd_tp_tx
--				Left Join item_Fat FAT on CC.num_proc_HEA = FAT.num_proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hea = FAT.dc
--				Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1 
				Join Pessoa_ATL_AX P on P.cd_pes=HOU.cd_export_hea and Tipo='C'

				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_hea and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hea=fat.dc    
				Left join vwAXDocs AX on CC.Num_proc_hea = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_hea = ax.dc
				
				Left join vwSolPgtoCtaCteAprovadas S on CC.Num_proc_hea = S.Num_proc  and CC.cd_tp_tx = S.Cd_Tp_Tx and cc.dc_hea = S.dc
				left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CC.Num_NF_HEA and BA.Ref_Acesso =CC.Ref_Acesso_NF_HEA
			WHERE 
				CXA.Num_Lcto is null and 
				CC.Num_Proc_HEA = @Processo and Fat.num_proc is null --and F.FatCod is null
				and desp_dst_hea='N' and desat_tx='N'
				and id_ax is null
				and S.ID is null

		union all

			SELECT 
				distinct cc.cd_tp_moeda,dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Paridade,TT.Nome_tp_tx,vlr_org_HEO*dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Valor, CC.cd_tp_tx, CC.cd_cred_dev_heo Cd_Pes,cc.dc_heo 
				,CC.num_nf_heo NF, CC.ref_acesso_nf_heo [Site]
				,Repasse_TX ,
				isnull(BA.Emissao,GETDATE()) Emissao
			FROM 
				Cta_Cte_Hou_Exp_Out CC
				left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
				Join House_Exp_Out HOU with(nolock) on HOU.num_proc_HEO = CC.num_proc_HEO and HOU.cd_export_heo = cc.cd_cred_dev_heo
				Left join Caixa_Hou_Exp_Out CXA on	CC.num_proc_HEO	= CXA.num_proc_HEO and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HEO = CXA.dc_HEO and num_lcto <> 'PROVISÓRIO'
--				Left Join fatura_chb_item FAT on CC.num_proc_HEO = left(FAT.Fatura_CC,16) and CC.cd_tp_tx = FAT.cd_tp_tx
--				Left Join item_Fat FAT on CC.num_proc_HEO = FAT.num_proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_heo = FAT.dc
--				Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1
				Join Pessoa_ATL_AX P on P.cd_pes=HOU.cd_export_heo and Tipo='C'

				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_heo and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_heo=fat.dc    
				Left join vwAXDocs AX on CC.Num_proc_heo = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_heo = ax.dc
				
				Left join vwSolPgtoCtaCteAprovadas S on CC.Num_proc_heo = S.Num_proc  and CC.cd_tp_tx = S.Cd_Tp_Tx and cc.dc_heo = S.dc
				left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CC.Num_NF_HEO and BA.Ref_Acesso =CC.Ref_Acesso_NF_HEO
			WHERE 
				CXA.Num_Lcto is null and 
				CC.Num_Proc_HEO = @Processo and Fat.num_proc is null --and F.FatCod is null
				and desp_org_heo='N' and desat_tx='N'
				and id_ax is null
				and S.ID is null

		union all

			SELECT 
				distinct cc.cd_tp_moeda,dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Paridade,TT.Nome_tp_tx,vlr_org_HIM*dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Valor, CC.cd_tp_tx, CC.cd_cred_dev_him Cd_Pes,cc.dc_him 
				,CC.num_nf_him NF, CC.ref_acesso_nf_him [Site]
				,Repasse_TX ,
				isnull(BA.Emissao,GETDATE()) Emissao
			FROM 
				Cta_Cte_Hou_Imp_Mar CC
				left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
				Join House_Imp_Mar HOU with(nolock) on HOU.num_proc_HIM = CC.num_proc_HIM and HOU.cd_consig_him = cc.cd_cred_dev_him
				Left join Caixa_Hou_Imp_Mar CXA on	CC.num_proc_HIM	= CXA.num_proc_HIM and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HIM = CXA.dc_HIM and num_lcto <> 'PROVISÓRIO'
--				Left Join fatura_chb_item FAT on CC.num_proc_HIM = left(FAT.Fatura_CC,16) and CC.cd_tp_tx = FAT.cd_tp_tx
--				Left Join item_Fat FAT on CC.num_proc_HIM = FAT.num_proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_him = FAT.dc
--				Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1 
				Join Pessoa_ATL_AX P on P.cd_pes=HOU.cd_consig_him and Tipo='C'

				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_him and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_him=fat.dc   
				Left join vwAXDocs AX on CC.Num_proc_him = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_him = ax.dc
				
				Left join vwSolPgtoCtaCteAprovadas S on CC.Num_proc_him = S.Num_proc  and CC.cd_tp_tx = S.Cd_Tp_Tx and cc.dc_him = S.dc
				left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CC.Num_NF_HIM and BA.Ref_Acesso =CC.Ref_Acesso_NF_HIM
			WHERE 
				CXA.Num_Lcto is null and 
				CC.Num_Proc_HIM = @Processo and Fat.num_proc is null --and F.FatCod is null
				and desp_org_him='N' and desat_tx='N'
				and id_ax is null
				and S.ID is null

		union all

			SELECT 
				distinct cc.cd_tp_moeda,dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Paridade,TT.Nome_tp_tx,vlr_org_HIA*dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Valor, CC.cd_tp_tx, CC.cd_cred_dev_hia Cd_Pes,cc.dc_hia 
				,CC.num_nf_hia NF, CC.ref_acesso_nf_hia [Site]
				,Repasse_TX ,
				isnull(BA.Emissao,GETDATE()) Emissao
			FROM 
				Cta_Cte_Hou_Imp_Aer CC
				left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
				Join House_Imp_Aer HOU with(nolock) on HOU.num_proc_HIA = CC.num_proc_HIA and HOU.cd_consig_hia = cc.cd_cred_dev_hia
				Left join Caixa_Hou_Imp_Aer CXA on	CC.num_proc_HIA	= CXA.num_proc_HIA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HIA = CXA.dc_HIA and num_lcto <> 'PROVISÓRIO'
--				Left Join fatura_chb_item FAT on CC.num_proc_HIA = left(FAT.Fatura_CC,16) and CC.cd_tp_tx = FAT.cd_tp_tx
--				Left Join item_Fat FAT on CC.num_proc_HIA = FAT.num_proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hia = FAT.dc
--				Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1	
				Join Pessoa_ATL_AX P on P.cd_pes=HOU.cd_consig_hia and Tipo='C'

				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_hia and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hia=fat.dc   
				Left join vwAXDocs AX on CC.Num_proc_hia = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_hia = ax.dc
				
				Left join vwSolPgtoCtaCteAprovadas S on CC.Num_proc_hia = S.Num_proc  and CC.cd_tp_tx = S.Cd_Tp_Tx and cc.dc_hia= S.dc
				left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CC.Num_NF_Hia and BA.Ref_Acesso =CC.Ref_Acesso_NF_Hia
			WHERE 
				CXA.Num_Lcto is null and 
				CC.Num_Proc_HIA = @Processo and Fat.num_proc is null --and F.FatCod is null
				and desp_org_hia='N' and desat_tx='N'
				and id_ax is null
				and S.ID is null

		union all

			SELECT 
				distinct cc.cd_tp_moeda,dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Paridade,TT.Nome_tp_tx,vlr_org_HIO*dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Valor, CC.cd_tp_tx, CC.cd_cred_dev_hio Cd_Pes,cc.dc_hio 
				,CC.num_nf_hio NF, CC.ref_acesso_nf_hio [Site]
				,Repasse_TX ,
				isnull(BA.Emissao,GETDATE()) Emissao
			FROM 
				Cta_Cte_Hou_Imp_Out CC
				left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
				Join House_Imp_Out HOU with(nolock) on HOU.num_proc_HIO = CC.num_proc_HIO and HOU.cd_consig_hio = cc.cd_cred_dev_hio
				Left join Caixa_Hou_Imp_Out CXA on	CC.num_proc_HIO	= CXA.num_proc_HIO and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HIO = CXA.dc_HIO and num_lcto <> 'PROVISÓRIO'
--				Left Join fatura_chb_item FAT on CC.num_proc_HIO = left(FAT.Fatura_CC,16) and CC.cd_tp_tx = FAT.cd_tp_tx
--				Left Join item_Fat FAT on CC.num_proc_HIO = FAT.num_proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hio = FAT.dc
--				Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1
				Join Pessoa_ATL_AX P on P.cd_pes=HOU.cd_consig_hio and Tipo='C'

				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_hio and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hio=fat.dc   
				Left join vwAXDocs AX on CC.Num_proc_hio = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_hio = ax.dc
				
				Left join vwSolPgtoCtaCteAprovadas S on CC.Num_proc_hio = S.Num_proc  and CC.cd_tp_tx = S.Cd_Tp_Tx and cc.dc_hio= S.dc
				left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CC.Num_NF_Hio and BA.Ref_Acesso =CC.Ref_Acesso_NF_Hio
			WHERE 
				CXA.Num_Lcto is null 	and 
				CC.Num_Proc_HIO = @Processo and Fat.num_proc is null
				and desp_org_hio='N' and desat_tx='N'
				and id_ax is null
				and S.ID is null

		--incluido master EA		
		UNION ALL

			SELECT 
				distinct cc.cd_tp_moeda,dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Paridade,TT.Nome_tp_tx,vlr_org_MEA*dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Valor, CC.cd_tp_tx, CC.cd_cred_dev_mea Cd_Pes,cc.dc_mea 
				,CC.num_nf_mea NF, CC.ref_acesso_nf_mea [Site]
				,Repasse_TX ,
				isnull(BA.Emissao,GETDATE()) Emissao				
			FROM 
				Cta_Cte_MAS_Exp_Aer CC
				left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
				Join Master_Exp_Aer HOU with(nolock) on HOU.num_proc_MEA = CC.num_proc_MEA and HOU.cd_export_mea = cc.cd_cred_dev_mea
				Left join Caixa_mas_Exp_Aer CXA on	CC.num_proc_MEA	= CXA.num_proc_MEA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_MEA = CXA.dc_MEA and num_lcto <> 'PROVISÓRIO'
	--			Left Join fatura_chb_item FAT on CC.num_proc_HEA = left(FAT.Fatura_CC,16) and CC.cd_tp_tx = FAT.cd_tp_tx
--				Left Join item_Fat FAT on CC.num_proc_HEA = FAT.num_proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hea = FAT.dc
--				Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1 
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_mea and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_mea=fat.dc    
				Left join vwAXDocs AX on CC.Num_proc_mea = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_mea = ax.dc
				Join Pessoa_ATL_AX P on P.cd_pes=HOU.cd_export_mea and Tipo='C'
				
				Left join vwSolPgtoCtaCteAprovadas S on CC.Num_proc_mea = S.Num_proc  and CC.cd_tp_tx = S.Cd_Tp_Tx and cc.dc_mea = S.dc
				left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CC.Num_NF_MEA and BA.Ref_Acesso =CC.Ref_Acesso_NF_MEA

			WHERE 				
				CXA.Num_Lcto is null 	and 
				CC.Num_Proc_MEA = @Processo 
				and Fat.num_proc is null --and F.FatCod is null
				and desp_dst_mea='N' and desat_tx='N'
				and id_ax is null
				and S.ID is null
		
		Union All
		
			SELECT 
				distinct cc.cd_tp_moeda,dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Paridade,TT.Nome_tp_tx,vlr_org_mim*dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'IMM') Valor, CC.cd_tp_tx, CC.cd_cred_dev_mim Cd_Pes,cc.dc_mim 
				,CC.num_nf_mim NF, CC.ref_acesso_nf_mim [Site]
				,Repasse_TX	 ,
				isnull(BA.Emissao,GETDATE()) Emissao			
			FROM 
				Cta_Cte_MAS_imp_mar CC
				left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
				Join Master_imp_mar HOU with(nolock) on HOU.num_proc_mim = CC.num_proc_mim and HOU.cd_export_mim = cc.cd_cred_dev_mim
				Left join Caixa_mas_imp_mar CXA on	CC.num_proc_mim	= CXA.num_proc_mim and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_mim = CXA.dc_mim and num_lcto <> 'PROVISÓRIO'
	--			Left Join fatura_chb_item FAT on CC.num_proc_HEA = left(FAT.Fatura_CC,16) and CC.cd_tp_tx = FAT.cd_tp_tx
--				Left Join item_Fat FAT on CC.num_proc_HEA = FAT.num_proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hea = FAT.dc
--				Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1 
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_mim and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_mim=fat.dc    
				Left join vwAXDocs AX on CC.Num_proc_mim = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_mim = ax.dc
				Join Pessoa_ATL_AX P on P.cd_pes=HOU.cd_consig_mim and Tipo='C'

				Left join vwSolPgtoCtaCteAprovadas S on CC.Num_proc_mim = S.Num_proc  and CC.cd_tp_tx = S.Cd_Tp_Tx and cc.dc_mim = S.dc
				left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CC.Num_NF_mim and BA.Ref_Acesso =CC.Ref_Acesso_NF_MIM
			WHERE 				
				CXA.Num_Lcto is null 	and 
				CC.Num_Proc_mim = @Processo 
				and Fat.num_proc is null --and F.FatCod is null
				and desp_org_mim='N' and desat_tx='N'
				and id_ax is null
				and S.ID is null		
		
		end
	else
		begin
		Insert @TempTaxas
			SELECT 
				distinct cc.cd_tp_moeda Moeda,
--				1 Paridade,
				(case When
					CC.Num_NF_HEM is not NULL and CC.ref_acesso_nf_hem <> 'P'
				Then 
					CC.Par_NF_Hem 
				else 
					dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') end ) Paridade,				
--				sum(isnull([dbo].[fParidadeFaturaARG](I.num_proc,cd_tp_moeda),dbo.FConverterMoeda(cd_tp_moeda,'REL')) * dbo.valor(vlr_org,DC)) Valor,					
 
				TT.Nome_tp_tx,vlr_org_HEM Valor, CC.cd_tp_tx, CC.cd_cred_dev_hem Cd_Pes,cc.dc_hem DC 
				,CC.num_nf_hem NF, CC.ref_acesso_nf_hem [Site]
				,Repasse_TX ,
				isnull(BA.Emissao,GETDATE()) Emissao
			FROM Cta_Cte_Hou_Exp_Mar CC
				left Join Tipo_Taxa TT on CC.cd_tp_tx = TT.cd_tp_tx
				Left join Caixa_Hou_Exp_Mar CXA on	CC.num_proc_HEM	= CXA.num_proc_HEM and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HEM = CXA.dc_HEM and num_lcto <> 'PROVISÓRIO'
		--		Left Join fatura_chb_item FAT on CC.num_proc_HEM = left(FAT.Fatura_CC,16) and CC.cd_tp_tx = FAT.cd_tp_tx
				--Left Join item_Fat FAT on CC.num_proc_HEM = FAT.num_proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hem = FAT.dc
			--	Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1 
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_hem and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hem=fat.dc
				Left join vwAXDocs AX on CC.Num_proc_hem = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_hem = ax.dc
				Join Pessoa_ATL_AX P on P.cd_pes=@cdPes and Tipo='C'

				Left join vwSolPgtoCtaCteAprovadas S on CC.Num_proc_hem = S.Num_proc  and CC.cd_tp_tx = S.Cd_Tp_Tx and cc.dc_hem = S.dc
				left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CC.Num_NF_HEM and BA.Ref_Acesso =CC.Ref_Acesso_NF_HEM
			WHERE 
				CXA.Num_Lcto is null and 
				CC.Num_Proc_HEM = @Processo and Fat.num_proc is null and CC.cd_cred_dev_hem = @cdPes
				and desp_dst_hem='N' and desat_tx='N'
				and id_ax is null
				and S.ID is null
				
		union all

			SELECT 
				distinct cc.cd_tp_moeda,
--				1 Paridade,		
								(case When
					CC.Num_NF_HEA is not NULL and CC.ref_acesso_nf_hea <> 'P'
				Then 
					CC.Par_NF_HeA 
				else 
					dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') end ) Paridade, 
				TT.Nome_tp_tx,vlr_org_HEA Valor, CC.cd_tp_tx, CC.cd_cred_dev_hea Cd_Pes,cc.dc_hea DC 
				,CC.num_nf_hea NF, CC.ref_acesso_nf_hea [Site]
				,Repasse_TX ,
				isnull(BA.Emissao,GETDATE()) Emissao
			FROM 
				Cta_Cte_Hou_Exp_Aer CC
				left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
				Left join Caixa_Hou_Exp_Aer CXA on	CC.num_proc_HEA	= CXA.num_proc_HEA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HEA = CXA.dc_HEA and num_lcto <> 'PROVISÓRIO'
--				Left Join fatura_chb_item FAT on CC.num_proc_HEA = left(FAT.Fatura_CC,16) and CC.cd_tp_tx = FAT.cd_tp_tx
--				Left Join item_Fat FAT on CC.num_proc_HEA = FAT.num_proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hea = FAT.dc
--				Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_hea and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hea=fat.dc
				Left join vwAXDocs AX on CC.Num_proc_hea = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_hea = ax.dc
				Join Pessoa_ATL_AX P on P.cd_pes=@cdPes and Tipo='C'
				
				Left join vwSolPgtoCtaCteAprovadas S on CC.Num_proc_hea = S.Num_proc  and CC.cd_tp_tx = S.Cd_Tp_Tx and cc.dc_hea= S.dc
				left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CC.Num_NF_HEa and BA.Ref_Acesso =CC.Ref_Acesso_NF_HEA

			WHERE 
				CXA.Num_Lcto is null and 
				CC.Num_Proc_HEA = @Processo and Fat.num_proc is null and CC.cd_cred_dev_hea = @cdPes
				and desp_dst_hea='N' and desat_tx='N'
				and id_ax is null
				and S.ID is null

		union all

			SELECT 
				distinct cc.cd_tp_moeda,
--				1 Paridade,
								(case When
					CC.Num_NF_HEO is not NULL and CC.ref_acesso_nf_heo <> 'P'
				Then 
					CC.Par_NF_HeO 
				else 
					dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') end ) Paridade,
				TT.Nome_tp_tx,vlr_org_HEO Valor, CC.cd_tp_tx, CC.cd_cred_dev_heo Cd_Pes,cc.dc_heo DC 
				,CC.num_nf_heo NF, CC.ref_acesso_nf_heo [Site]
				,Repasse_TX ,
				isnull(BA.Emissao,GETDATE()) Emissao 
			FROM 
				Cta_Cte_Hou_Exp_Out CC
				left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
				Left join Caixa_Hou_Exp_Out CXA on	CC.num_proc_HEO	= CXA.num_proc_HEO and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HEO = CXA.dc_HEO and num_lcto <> 'PROVISÓRIO'
--				Left Join fatura_chb_item FAT on CC.num_proc_HEO = left(FAT.Fatura_CC,16) and CC.cd_tp_tx = FAT.cd_tp_tx
--				Left Join item_Fat FAT on CC.num_proc_HEO = FAT.num_proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_heo = FAT.dc
--				Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_heo and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_heo=fat.dc
				Left join vwAXDocs AX on CC.Num_proc_heo = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_heo = ax.dc
				Join Pessoa_ATL_AX P on P.cd_pes=@cdPes and Tipo='C'
				
				Left join vwSolPgtoCtaCteAprovadas S on CC.Num_proc_heo = S.Num_proc  and CC.cd_tp_tx = S.Cd_Tp_Tx and cc.dc_heo = S.dc
				left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CC.Num_NF_HEO and BA.Ref_Acesso =CC.Ref_Acesso_NF_HEO

			WHERE 
				CXA.Num_Lcto is null and 
				CC.Num_Proc_HEO = @Processo and Fat.num_proc is null and CC.cd_cred_dev_heo = @cdPes
				and desp_org_heo='N' and desat_tx='N'
				and id_ax is null
				and S.ID is null

		union all

			SELECT 
				distinct cc.cd_tp_moeda,
--				1 Paridade,
								(case When
					CC.Num_NF_HIM is not NULL and CC.ref_acesso_nf_him <> 'P'
				Then 
					CC.Par_NF_HIM 
				else 
					dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') end ) Paridade,
				TT.Nome_tp_tx,vlr_org_HIM Valor, CC.cd_tp_tx, CC.cd_cred_dev_him Cd_Pes,CC.dc_him 
				,CC.num_nf_him NF, CC.ref_acesso_nf_him [Site]
				,Repasse_TX ,
				isnull(BA.Emissao,GETDATE()) Emissao
			FROM 
				Cta_Cte_Hou_Imp_Mar CC
				left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
				Left join Caixa_Hou_Imp_Mar CXA on	CC.num_proc_HIM	= CXA.num_proc_HIM and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HIM = CXA.dc_HIM and num_lcto <> 'PROVISÓRIO'
--				Left Join fatura_chb_item FAT on CC.num_proc_HIM = left(FAT.Fatura_CC,16) and CC.cd_tp_tx = FAT.cd_tp_tx
--				Left Join item_Fat FAT on CC.num_proc_HIM = FAT.num_proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_him = FAT.dc
--				Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_him and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_him=fat.dc 
				Left join vwAXDocs AX on CC.Num_proc_him = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_him = ax.dc
				Join Pessoa_ATL_AX P on P.cd_pes=@cdPes and Tipo='C'
				
				Left join vwSolPgtoCtaCteAprovadas S on CC.Num_proc_him = S.Num_proc  and CC.cd_tp_tx = S.Cd_Tp_Tx and cc.dc_him = S.dc
				left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CC.Num_NF_HIM and BA.Ref_Acesso =CC.Ref_Acesso_NF_HIM

			WHERE 
				CXA.Num_Lcto is null and 
				CC.Num_Proc_HIM = @Processo and Fat.num_proc is null and CC.cd_cred_dev_him = @cdPes
				and desp_org_him='N' and desat_tx='N' 
				and id_ax is null
				and S.ID is null

		union all

			SELECT 
				distinct cc.cd_tp_moeda,
--				1 Paridade,
								(case When
					CC.Num_NF_HIA is not NULL and CC.ref_acesso_nf_hia <> 'P'
				Then 
					CC.Par_NF_HIA 
				else 
					dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') end ) Paridade,
				TT.Nome_tp_tx,vlr_org_HIA Valor, CC.cd_tp_tx, CC.cd_cred_dev_hia Cd_Pes,cc.dc_hia 
				,CC.num_nf_hia NF, CC.ref_acesso_nf_hia [Site]
				,Repasse_TX ,
				isnull(BA.Emissao,GETDATE()) Emissao
			FROM 
				Cta_Cte_Hou_Imp_Aer CC
				left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
				Left join Caixa_Hou_Imp_Aer CXA on	CC.num_proc_HIA	= CXA.num_proc_HIA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HIA = CXA.dc_HIA and num_lcto <> 'PROVISÓRIO'
--				Left Join fatura_chb_item FAT on CC.num_proc_HIA = left(FAT.Fatura_CC,16) and CC.cd_tp_tx = FAT.cd_tp_tx
--				Left Join item_Fat FAT on CC.num_proc_HIA = FAT.num_proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hia = FAT.dc
--				Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1	
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_hia and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hia=fat.dc 
				Left join vwAXDocs AX on CC.Num_proc_hia = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_hia = ax.dc
				Join Pessoa_ATL_AX P on P.cd_pes=@cdPes and Tipo='C'
				
				Left join vwSolPgtoCtaCteAprovadas S on CC.Num_proc_hia = S.Num_proc  and CC.cd_tp_tx = S.Cd_Tp_Tx and cc.dc_hia = S.dc
				left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CC.Num_NF_HIA and BA.Ref_Acesso =CC.Ref_Acesso_NF_HIA

			WHERE 
				CXA.Num_Lcto is null  and 
				CC.Num_Proc_HIA = @Processo and Fat.num_proc is null and CC.cd_cred_dev_hia = @cdPes
				and desp_org_hia='N' and desat_tx='N'
				and id_ax is null
				and S.ID is null

		union all

			SELECT 
				distinct cc.cd_tp_moeda,
--				1 Paridade,
				(case When
					CC.Num_NF_HIO is not NULL and CC.ref_acesso_nf_hio <> 'P'
				Then 
					CC.Par_NF_HIO 
				else 
					dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') end ) Paridade,
				TT.Nome_tp_tx,vlr_org_HIO Valor, CC.cd_tp_tx, CC.cd_cred_dev_hio Cd_Pes,cc.dc_hio 
				,CC.num_nf_hio NF, CC.ref_acesso_nf_hio [Site]
				,Repasse_TX ,
				isnull(BA.Emissao,GETDATE()) Emissao
			FROM 
				Cta_Cte_Hou_Imp_Out CC
				left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
				Left join Caixa_Hou_Imp_Out CXA on	CC.num_proc_HIO	= CXA.num_proc_HIO and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_HIO = CXA.dc_HIO and num_lcto <> 'PROVISÓRIO'
--				Left Join fatura_chb_item FAT on CC.num_proc_HIO = left(FAT.Fatura_CC,16) and CC.cd_tp_tx = FAT.cd_tp_tx
--				Left Join item_Fat FAT on CC.num_proc_HIO = FAT.num_proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hio = FAT.dc
--				Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_hio and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_hio=fat.dc  
				Left join vwAXDocs AX on CC.Num_proc_hio = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_hio = ax.dc
				Join Pessoa_ATL_AX P on P.cd_pes=@cdPes and Tipo='C'
				
				Left join vwSolPgtoCtaCteAprovadas S on CC.Num_proc_hio = S.Num_proc  and CC.cd_tp_tx = S.Cd_Tp_Tx and cc.dc_hio= S.dc
				left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CC.Num_NF_HIO and BA.Ref_Acesso =CC.Ref_Acesso_NF_HIO
				

			WHERE 
				CXA.Num_Lcto is null and 
				CC.Num_Proc_HIO = @Processo and Fat.num_proc is null and  CC.cd_cred_dev_hio = @cdPes
				and desp_org_hio='N' and desat_tx='N'
				and id_ax is null
				and S.ID is null


		UNION all
		---Incluido Master EA
			SELECT 
				distinct cc.cd_tp_moeda,
--				1 Paridade,		
								(case When 
					CC.Num_NF_MEA is not NULL and CC.ref_acesso_nf_mea <> 'P'
				Then 
					CC.Par_NF_MeA 
				else 
					dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') end ) Paridade, 
				TT.Nome_tp_tx,vlr_org_MEA Valor, CC.cd_tp_tx, CC.cd_cred_dev_mea Cd_Pes,cc.dc_mea DC 
				,CC.num_nf_mea NF, CC.ref_acesso_nf_mea [Site]
				,Repasse_TX ,
				isnull(BA.Emissao,GETDATE()) Emissao
			FROM 
				Cta_Cte_MAS_Exp_Aer CC
				left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
				Left join Caixa_MAS_Exp_Aer CXA on	CC.num_proc_MEA	= CXA.num_proc_MEA and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_MEA = CXA.dc_MEA and num_lcto <> 'PROVISÓRIO'
--				Left Join fatura_chb_item FAT on CC.num_proc_HEA = left(FAT.Fatura_CC,16) and CC.cd_tp_tx = FAT.cd_tp_tx 
--				Left Join item_Fat FAT on CC.num_proc_HEA = FAT.num_proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hea = FAT.dc
--				Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_mea and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_mea=fat.dc
				Left join vwAXDocs AX on CC.Num_proc_mea = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_mea = ax.dc
				Join Pessoa_ATL_AX P on P.cd_pes=@cdPes and Tipo='C'
				
				Left join vwSolPgtoCtaCteAprovadas S on CC.Num_proc_mea = S.Num_proc  and CC.cd_tp_tx = S.Cd_Tp_Tx and cc.dc_mea = S.dc
				left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CC.Num_NF_MEA and BA.Ref_Acesso =CC.Ref_Acesso_NF_MEA

			WHERE 
				CXA.Num_Lcto is null and 
				CC.Num_Proc_MEA = @Processo and Fat.num_proc is null and CC.cd_cred_dev_mea = @cdPes
				and desp_dst_mea='N' and desat_tx='N'
				and id_ax is null
				and S.ID is null
			
		Union all
	
			SELECT 
				distinct cc.cd_tp_moeda,
--				1 Paridade,		
								(case When 
					CC.Num_NF_mim is not NULL and CC.ref_acesso_nf_mim <> 'P'
				Then 
					CC.Par_NF_mim 
				else 
					dbo.verparidade(convert(varchar(10),getdate(),103),cc.cd_tp_moeda,'OFC') end ) Paridade, 
				TT.Nome_tp_tx,vlr_org_mim Valor, CC.cd_tp_tx, CC.cd_cred_dev_mim Cd_Pes,cc.dc_mim DC 
				,CC.num_nf_mim NF, CC.ref_acesso_nf_mim [Site]
				,Repasse_TX ,
				isnull(BA.Emissao,GETDATE()) Emissao
			FROM 
				Cta_Cte_MAS_imp_mar CC
				left Join Tipo_Taxa TT	on CC.cd_tp_tx = TT.cd_tp_tx
				Left join Caixa_MAS_imp_mar CXA on	CC.num_proc_mim	= CXA.num_proc_mim and CC.cd_tp_tx = CXA.cd_tp_tx and CC.dc_mim = CXA.dc_mim and num_lcto <> 'PROVISÓRIO'
--				Left Join fatura_chb_item FAT on CC.num_proc_HEA = left(FAT.Fatura_CC,16) and CC.cd_tp_tx = FAT.cd_tp_tx 
--				Left Join item_Fat FAT on CC.num_proc_HEA = FAT.num_proc and CC.cd_tp_tx = FAT.cd_tp_tx and CC.dc_hea = FAT.dc
--				Left Join Fatura F on F.FatCod=FAT.FatCod and F.FatStatus = 1
				Left Join @Fatura FAt on fat.num_proc=cc.num_proc_mim and cc.cd_tp_Tx=FAt.cd_tp_tx and cc.dc_mim=fat.dc
				Left join vwAXDocs AX on CC.Num_proc_mim = AX.Num_proc  and CC.cd_tp_tx = AX.Cd_Tp_Tx_ATL and cc.dc_mim = ax.dc
				Join Pessoa_ATL_AX P on P.cd_pes=@cdPes and Tipo='C'
				
				Left join vwSolPgtoCtaCteAprovadas S on CC.Num_proc_mim = S.Num_proc  and CC.cd_tp_tx = S.Cd_Tp_Tx and cc.dc_mim = S.dc
				left join Base_Nota_Fiscal BA With(nolock) on BA.Nota_Fiscal = CC.Num_NF_MIM and BA.Ref_Acesso =CC.Ref_Acesso_NF_MIM

			WHERE 
				CXA.Num_Lcto is null and 
				CC.Num_Proc_mim = @Processo and Fat.num_proc is null and CC.cd_cred_dev_mim = @cdPes
				and desp_org_mim='N' and desat_tx='N'
				and id_ax is null
				and S.ID is null


	end

--insert @TempTaxas1
--	select * from @TempTaxas
--	where NF is not NULL 
	
--update 
--	T  
--set 
--	T.Paridade=T1.Paridade
--from 
--	@TempTaxas as T
--JOIN
--	@TempTaxas1  as T1
--	on T.Moeda = T1.Moeda and T1.NF is not NULL
	
update 
	T  
set 
	T.Paridade=T1.Paridade
from 
	@TempTaxas as T
JOIN
	@TempTaxas  as T1
	on T.Moeda = T1.Moeda and T1.NF is not NULL
--select Moeda,Paridade from @TempTaxas as T2 where NF is not NULL
--where NF is NULL
	
select * from @TempTaxas where month(Emissao) = MONTH(getdate())

*/

*/

GO
