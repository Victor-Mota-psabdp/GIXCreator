SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spTaxasBDPInvoiceCadu_Sel]-- spTaxasBDPInvoice_Sel 'EAGRU201610007', 'ABSA - 1691C'
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
	
select * from @TempTaxas --where month(Emissao) = MONTH(getdate()) 


/*OLd ONe


ALTER procedure [dbo].[spTaxasBDPInvoiceCadu_Sel]-- spTaxasBDPInvoice_Sel 'EMOXT201310068BR', 'OXITENO NORDESTE'
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
	
select * from @TempTaxas 
--where month(Emissao) = MONTH(getdate()) 




*/
GO
