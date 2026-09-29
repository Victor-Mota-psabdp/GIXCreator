SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Tipo_LI
--sp_help Solicitacao_LI
--select * from Solicitacao_LI
CREATE PROCEDURE [dbo].[spATL_Solicitacao_LI_Sel]
(
	@Num_Solicitacao	varchar(13),
	@Tipo				char(1)
)

as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select 
			SLI.Num_Solicitacao			[Code],
			SLI.Dt_Solicitacao			[Register Date],
			SLI.Cd_Usuario_Req			[Requester User Code],
			REQ.Nome_Usuario			[Requester User Name],
			SLI.ID_Tipo_LI				[IL Type Code],
			TL.Nome_Tp_LI				[IL Type Name],
			SLI.cd_grupo				[Group Code],
			GG.Apelido					[Group Name],	
			SLI.Num_Proc				[JOB],		
			SLI.Cd_Usuario_Oper			[Operator User Code],
			OPE.Nome_Usuario			[Operator User Name],			
			SLI.Num_LI					[IL Number],
			SLI.DT_LI					[IL Date],
			SLI.Dt_Aut_Embarque			[Shipment Approval Date],
			SLI.Dt_Deferimento			[Approval Date],
			SLI.Dt_Vencimento			[Issue Date],
			SLI.Protocolo_Transmissao	[Transmission Protocol],
			SLI.Num_Requerimento		[Requeriment Number],
			SLI.Dt_Requerimento			[Requeriment Date],
			SLI.CobrancaCliente			[No Charge to Customer],--Sem Cobrança do Cliente
			SLI.Cd_Fabricante			[Manufacturer Code],
			FAB.Apelido					[Manufacturer Name],
			SLI.ID_Status				[Status Code],
			TSL.Status_LI_Descricao		[Status Name],
			SLI.ID_Regime				[IL Regime Code],
			TR.Regime_Li_Descricao		[IL Regime Name],
			SLI.Motivo					[Import License Reason],
			SLI.Obs_LI					[Notes]		
		from Solicitacao_LI SLI with(nolock)
			left Join Tipo_LI TL with(nolock)on SLI.ID_Tipo_LI=TL.ID_Tipo
			Left Join Usuario REQ with(nolock) on SLI.Cd_Usuario_Req=REQ.Cd_Usuario
			Left Join Usuario OPE with(nolock) on SLI.Cd_Usuario_Oper=OPE.Cd_Usuario
			Left Join Pessoa FAB with(nolock) on FAB.Cd_Pes=SLI.Cd_Fabricante	
			Left Join Tipo_Status_LI TSL with(nolock) on SLI.ID_Status=TSL.ID_Status_LI	
			Left join Tipo_Regime_LI TR with(nolock) on SLI.ID_Regime=TR.ID_Regime_LI
			Left Join Pessoa GG with(nolock) on GG.cd_pes=SLI.cd_grupo
		ORDER BY 1
	END
	
if @Tipo = 'C' or @Tipo = 'D'
	Begin
		select 
			SLI.Num_Solicitacao			[Code],
			SLI.Dt_Solicitacao			[Register Date],
			SLI.Cd_Usuario_Req			[Requester User Code],
			REQ.Nome_Usuario			[Requester User Name],
			SLI.ID_Tipo_LI				[IL Type Code],
			TL.Nome_Tp_LI				[IL Type Name],
			SLI.cd_grupo				[Group Code],
			GG.Apelido					[Group Name],	
			SLI.Num_Proc				[JOB],		
			SLI.Cd_Usuario_Oper			[Operator User Code],
			OPE.Nome_Usuario			[Operator User Name],			
			SLI.Num_LI					[IL Number],
			SLI.DT_LI					[IL Date],
			SLI.Dt_Aut_Embarque			[Shipment Approval Date],
			SLI.Dt_Deferimento			[Approval Date],
			SLI.Dt_Vencimento			[Issue Date],
			SLI.Protocolo_Transmissao	[Transmission Protocol],
			SLI.Num_Requerimento		[Requeriment Number],
			SLI.Dt_Requerimento			[Requeriment Date],
			SLI.CobrancaCliente			[No Charge to Customer],--Sem Cobrança do Cliente
			SLI.Cd_Fabricante			[Manufacturer Code],
			FAB.Apelido					[Manufacturer Name],
			SLI.ID_Status				[Status Code],
			TSL.Status_LI_Descricao		[Status Name],
			SLI.ID_Regime				[IL Regime Code],
			TR.Regime_Li_Descricao		[IL Regime Name],
			SLI.Motivo					[Import License Reason],
			SLI.Obs_LI					[Notes]		
		from Solicitacao_LI SLI with(nolock)
			left Join Tipo_LI TL with(nolock)on SLI.ID_Tipo_LI=TL.ID_Tipo
			Left Join Usuario REQ with(nolock) on SLI.Cd_Usuario_Req=REQ.Cd_Usuario
			Left Join Usuario OPE with(nolock) on SLI.Cd_Usuario_Oper=OPE.Cd_Usuario
			Left Join Pessoa FAB with(nolock) on FAB.Cd_Pes=SLI.Cd_Fabricante	
			Left Join Tipo_Status_LI TSL with(nolock) on SLI.ID_Status=TSL.ID_Status_LI	
			Left join Tipo_Regime_LI TR with(nolock) on SLI.ID_Regime=TR.ID_Regime_LI
			Left Join Pessoa GG with(nolock) on GG.cd_pes=SLI.cd_grupo
		Where
			Num_Solicitacao=@Num_Solicitacao
		ORDER BY 1	
			
	END
	
	/*select 
			SLI.Num_Solicitacao [Num_Solicitacao],SLI.Dt_Solicitacao,
			--Tipo_LI
			SLI.ID_Tipo_LI,TL.Nome_Tp_LI,
			--USUARIO REQ
			SLI.Cd_Usuario_Req,REQ.Nome_Usuario [Nome_Usuario_Req],
			--USUARIO OPER
			SLI.Cd_Usuario_Oper,OPE.Nome_Usuario [Nome_Usuario_Oper],
			SLI.Num_Proc [JOB],
			SLI.Num_LI [NumeroLI],SLI.DT_LI,SLI.Dt_Aut_Embarque,SLI.Dt_Deferimento,
			SLI.Dt_Vencimento,SLI.Protocolo_Transmissao,
			SLI.Motivo,
			SLI.Obs_LI,
			--Pessoa Fabricante
			SLI.Cd_Fabricante Cd_Pes_Fabricante,FAB.Apelido Apelido_Fabricante,			
			SLI.Num_Requerimento,SLI.Dt_Requerimento,
			--Tipo_Status_LI
			SLI.ID_Status ID_Status_LI,TSL.Status_LI_Descricao,
			SLI.CobrancaCliente,
			--Tipo_Regime_LI
			SLI.ID_Regime ID_Regime_LI,TR.Regime_Li_Descricao,
			--pessoa Grupo	
			SLI.cd_grupo Cd_Pes_Grupo,GG.Apelido Apelido_Grupo
		from Solicitacao_LI SLI with(nolock)
			left Join Tipo_LI TL with(nolock)on SLI.ID_Tipo_LI=TL.ID_Tipo
			Left Join Usuario REQ with(nolock) on SLI.Cd_Usuario_Req=REQ.Cd_Usuario
			Left Join Usuario OPE with(nolock) on SLI.Cd_Usuario_Oper=OPE.Cd_Usuario
			Left Join Pessoa FAB with(nolock) on FAB.Cd_Pes=SLI.Cd_Fabricante	
			Left Join Tipo_Status_LI TSL with(nolock) on SLI.ID_Status=TSL.ID_Status_LI	
			Left join Tipo_Regime_LI TR with(nolock) on SLI.ID_Regime=TR.ID_Regime_LI
			Left Join Pessoa GG with(nolock) on GG.cd_pes=SLI.cd_grupo
		Where
			Num_Solicitacao=@Num_Solicitacao
		ORDER BY 1*/

GO
