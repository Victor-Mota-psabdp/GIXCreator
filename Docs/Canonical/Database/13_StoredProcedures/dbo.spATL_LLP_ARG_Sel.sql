SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help LLP_ARG
CREATE procedure [dbo].[spATL_LLP_ARG_Sel]
(
	@Num_Proc varchar(16),
	@Tipo char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
Z /// Verifica Nome X Codigo

*/

if @Tipo = 'A'  or @Tipo = 'B'
	Begin
		select 
			LLP_ARG.Num_Proc									[JOB],
			LLP_ARG.Cd_Adua_Saida								[Exit Custom Code],
			ADUS.Nome_Aduana										[Exit Custom Name],
			LLP_ARG.Cd_Adua_Registro							[Participant Custom Code],
			ADUR.Nome_Aduana										[Participant Custom Name],
			isnull(LLP_ARG.Forma_Pgto,'Garantiza a 15 dias')	[Mode of Payment of the Export Rates],
			isnull(LLP_ARG.Condic_Pgto,'45 dias fecha BL')		[Export Payment Condition],
			LLP_ARG.Banco										[Bank],
			isnull(LLP_ARG.Coefic_Exp,'1.00000')				[Coefficient Rates of Export in FOB],
			isnull(LLP_ARG.Reemb_Exp,0)							[Reimbursement of Export],
			isnull(LLP_ARG.Comissao,0)							[Commissions],
			isnull(LLP_ARG.Royalties,0)							[Royalties],
			LLP_ARG.Imp_Nat										[Imported Nationalized],
			LLP_ARG.Imp_Temp									[Imported Temporary],
			LLP_ARG.Consolidacao								[Consolidation Date and Hour],
			LLP_ARG.ETA_BuenosAires								[ETA Buenos Aires],
			LLP.ETD												[ETD Date],

			LLP_ARG.Paridade_Oper								[Paridade_Oper],
			LLP_ARG.Tipo_Dest									[Tipo_Dest],
			LLP_ARG.Cd_Pes_Agente_ATA							[Cd_Pes_Agente_ATA],
			LLP_ARG.Vcto_Invoice								[Vcto_Invoice],
			LLP_ARG.Consig_CtaCte								[Consig_CtaCte]
		from dbo.LLP_ARG LLP_ARG with(nolock)
			Left Join Aduanas_ARG	ADUS with(nolock)	on LLP_ARG.Cd_Adua_Saida=ADUS.CodAduana		
			Left Join Aduanas_ARG	ADUR with(nolock)	on LLP_ARG.Cd_Adua_Registro=ADUR.CodAduana
			Left Join vwHouse_Exp	LLP	 with(nolock)	on LLP_ARG.Num_Proc=LLP.Num_Proc			
		where
			LLP_ARG.Num_Proc = @Num_Proc 		 
	End	


if @Tipo = 'C'  or @Tipo = 'D' 
	Begin
		select 
			LLP_ARG.Num_Proc									[JOB],
			LLP_ARG.Cd_Adua_Saida								[Exit Custom Code],
			ADUS.Nome_Aduana										[Exit Custom Name],
			LLP_ARG.Cd_Adua_Registro							[Participant Custom Code],
			ADUR.Nome_Aduana										[Participant Custom Name],
			isnull(LLP_ARG.Forma_Pgto,'Garantiza a 15 dias')	[Mode of Payment of the Export Rates],
			isnull(LLP_ARG.Condic_Pgto,'45 dias fecha BL')		[Export Payment Condition],
			LLP_ARG.Banco										[Bank],
			isnull(LLP_ARG.Coefic_Exp,'1.00000')				[Coefficient Rates of Export in FOB],
			isnull(LLP_ARG.Reemb_Exp,0)							[Reimbursement of Export],
			isnull(LLP_ARG.Comissao,0)							[Commissions],
			isnull(LLP_ARG.Royalties,0)							[Royalties],
			LLP_ARG.Imp_Nat										[Imported Nationalized],
			LLP_ARG.Imp_Temp									[Imported Temporary],
			LLP_ARG.Consolidacao								[Consolidation Date and Hour],
			LLP_ARG.ETA_BuenosAires								[ETA Buenos Aires],
			LLP.ETD												[ETD Date],

			LLP_ARG.Paridade_Oper								[Paridade_Oper],
			LLP_ARG.Tipo_Dest									[Tipo_Dest],
			LLP_ARG.Cd_Pes_Agente_ATA							[Cd_Pes_Agente_ATA],
			LLP_ARG.Vcto_Invoice								[Vcto_Invoice],
			LLP_ARG.Consig_CtaCte								[Consig_CtaCte]
		from dbo.LLP_ARG LLP_ARG with(nolock)
			Left Join Aduanas_ARG	ADUS with(nolock)	on LLP_ARG.Cd_Adua_Saida=ADUS.CodAduana		
			Left Join Aduanas_ARG	ADUR with(nolock)	on LLP_ARG.Cd_Adua_Registro=ADUR.CodAduana
			Left Join vwHouse_Exp	LLP	 with(nolock)	on LLP_ARG.Num_Proc=LLP.Num_Proc			
		where
			LLP_ARG.Num_Proc = @Num_Proc 		 
	End	
if @Tipo = 'N'  or @Tipo = 'O'
	Begin
		select 
			LLP_ARG.Num_Proc									[JOB],
			LLP_ARG.Cd_Adua_Saida								[Exit Custom Code],
			ADUS.Nome_Aduana										[Exit Custom Name],
			LLP_ARG.Cd_Adua_Registro							[Participant Custom Code],
			ADUR.Nome_Aduana										[Participant Custom Name],
			isnull(LLP_ARG.Forma_Pgto,'Garantiza a 15 dias')	[Mode of Payment of the Export Rates],
			isnull(LLP_ARG.Condic_Pgto,'45 dias fecha BL')		[Export Payment Condition],
			LLP_ARG.Banco										[Bank],
			isnull(LLP_ARG.Coefic_Exp,'1.00000')				[Coefficient Rates of Export in FOB],
			isnull(LLP_ARG.Reemb_Exp,0)							[Reimbursement of Export],
			isnull(LLP_ARG.Comissao,0)							[Commissions],
			isnull(LLP_ARG.Royalties,0)							[Royalties],
			LLP_ARG.Imp_Nat										[Imported Nationalized],
			LLP_ARG.Imp_Temp									[Imported Temporary],
			LLP_ARG.Consolidacao								[Consolidation Date and Hour],
			LLP_ARG.ETA_BuenosAires								[ETA Buenos Aires],
			LLP.ETD												[ETD Date],

			LLP_ARG.Paridade_Oper								[Paridade_Oper],
			LLP_ARG.Tipo_Dest									[Tipo_Dest],
			LLP_ARG.Cd_Pes_Agente_ATA							[Cd_Pes_Agente_ATA],
			LLP_ARG.Vcto_Invoice								[Vcto_Invoice],
			LLP_ARG.Consig_CtaCte								[Consig_CtaCte]
		from dbo.LLP_ARG LLP_ARG with(nolock)
			Left Join Aduanas_ARG	ADUS with(nolock)	on LLP_ARG.Cd_Adua_Saida=ADUS.CodAduana		
			Left Join Aduanas_ARG	ADUR with(nolock)	on LLP_ARG.Cd_Adua_Registro=ADUR.CodAduana
			Left Join vwHouse_Exp	LLP	 with(nolock)	on LLP_ARG.Num_Proc=LLP.Num_Proc			
		where
			LLP_ARG.Num_Proc = @Num_Proc 			 
	End	


GO
