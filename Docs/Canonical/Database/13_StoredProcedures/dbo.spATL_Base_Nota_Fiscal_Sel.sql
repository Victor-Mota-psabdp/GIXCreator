SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_Base_Nota_Fiscal_Sel '','90881','I','N'
--sp_help Base_Nota_Fiscal
CREATE procedure [dbo].[spATL_Base_Nota_Fiscal_Sel]
(	
	@Nota_Fiscal	varchar(8),
	@Ref_Acesso		char(1),
	@Tipo			char(1)
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
		Select 		
			BNF.Nota_Fiscal		[Nota_Fiscal],
			BNF.Ref_Acesso		[Site Code],
			SI.Nome_Site		[Site Name],
			BNF.Emissao			[Register Date],
			BNF.Cd_Pes			[Customer Code],
			P.Apelido			[Customer Name],
			BNF.Tipo_Serv		[Service Type],
			BNF.Condicoes		[Conditions],
			BNF.Prazo			[Deadline],
			BNF.Cd_Status		[Status],
			BNF.Valor_Total		[Total Value],
			BNF.Observ_NF		[Notes],
			BNF.Aliq_ISS		[ISS Aliquota],
			BNF.Valor_ISS		[ISS Value],
			BNF.ISS_Retido		[ISS_Retido],
			BNF.RPS_Data		[RPS_Data],
			BNF.RPS_NFE			[RPS_NFE],
			BNF.RPS_NFE_Verif	[RPS_NFE_Verif],
			BNF.CdsId			[CdsId],
			BNF.SitId			[SitId],
			BNF.Aliq_ISS_Rps	[Aliq_ISS_Rps],
			BNF.RPS_Envio		[RPS_Envio],
			BNF.dt_Cancel		[Cancel Date],
			BNF.cd_usuario_cancel	[User Cancel Code],
			UC.Nome_Usuario			[User Cancel Name],
			BNF.Habilita_Impostos	[Habilita_Impostos],
			BNF.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name],
			BNF.cd_servico		[cd_servico],
			BNF.Item_lei		[Item_lei],
			BNF.CNAE			[CNAE],
			BNF.Descricao		[Description],
			BNF.dt_Protocolo	[Protocol Date],
			BNF.protocolo		[Protocol Number],
			BNF.dt_Cancel_Prefeitura	[NF Cancel Date],
			BNF.IRRF_Tx			[IRRF_Tx]
		from Base_Nota_Fiscal BNF  	with(nolock)	
		left join Site	SI 	with(nolock) on SI.Cd_Site = BNF.Ref_Acesso
		left join Pessoa P 	with(nolock) on P.cd_pes = BNF.Cd_Pes
		left join Usuario US 	with(nolock) on US.cd_usuario = BNF.cd_usuario
		left join Usuario UC 	with(nolock) on UC.cd_usuario = BNF.cd_usuario_cancel
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		Select 		
			BNF.Nota_Fiscal		[Nota_Fiscal],
			BNF.Ref_Acesso		[Site Code],
			SI.Nome_Site		[Site Name],
			BNF.Emissao			[Register Date],
			BNF.Cd_Pes			[Customer Code],
			P.Apelido			[Customer Name],
			BNF.Tipo_Serv		[Service Type],
			BNF.Condicoes		[Conditions],
			BNF.Prazo			[Deadline],
			BNF.Cd_Status		[Status],
			BNF.Valor_Total		[Total Value],
			BNF.Observ_NF		[Notes],
			BNF.Aliq_ISS		[ISS Aliquota],
			BNF.Valor_ISS		[ISS Value],
			BNF.ISS_Retido		[ISS_Retido],
			BNF.RPS_Data		[RPS_Data],
			BNF.RPS_NFE			[RPS_NFE],
			BNF.RPS_NFE_Verif	[RPS_NFE_Verif],
			BNF.CdsId			[CdsId],
			BNF.SitId			[SitId],
			BNF.Aliq_ISS_Rps	[Aliq_ISS_Rps],
			BNF.RPS_Envio		[RPS_Envio],
			BNF.dt_Cancel		[Cancel Date],
			BNF.cd_usuario_cancel	[User Cancel Code],
			UC.Nome_Usuario			[User Cancel Name],
			BNF.Habilita_Impostos	[Habilita_Impostos],
			BNF.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name],
			BNF.cd_servico		[cd_servico],
			BNF.Item_lei		[Item_lei],
			BNF.CNAE			[CNAE],
			BNF.Descricao		[Description],
			BNF.dt_Protocolo	[Protocol Date],
			BNF.protocolo		[Protocol Number],
			BNF.dt_Cancel_Prefeitura	[NF Cancel Date],
			BNF.IRRF_Tx			[IRRF_Tx]
		from Base_Nota_Fiscal BNF  	with(nolock)	
		left join Site	SI 	with(nolock) on SI.Cd_Site = BNF.Ref_Acesso
		left join Pessoa P 	with(nolock) on P.cd_pes = BNF.Cd_Pes
		left join Usuario US 	with(nolock) on US.cd_usuario = BNF.cd_usuario
		left join Usuario UC 	with(nolock) on UC.cd_usuario = BNF.cd_usuario_cancel
		where 
			BNF.Nota_Fiscal = @Nota_Fiscal and BNF.Ref_Acesso = @Ref_Acesso
	End	
	
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		Select 		
			BNF.Nota_Fiscal		[Nota_Fiscal],
			BNF.Ref_Acesso		[Site Code],
			SI.Nome_Site		[Site Name],
			BNF.Emissao			[Register Date],
			BNF.Cd_Pes			[Customer Code],
			P.Apelido			[Customer Name],
			BNF.Tipo_Serv		[Service Type],
			BNF.Condicoes		[Conditions],
			BNF.Prazo			[Deadline],
			BNF.Cd_Status		[Status],
			BNF.Valor_Total		[Total Value],
			BNF.Observ_NF		[Notes],
			BNF.Aliq_ISS		[ISS Aliquota],
			BNF.Valor_ISS		[ISS Value],
			BNF.ISS_Retido		[ISS_Retido],
			BNF.RPS_Data		[RPS_Data],
			BNF.RPS_NFE			[RPS_NFE],
			BNF.RPS_NFE_Verif	[RPS_NFE_Verif],
			BNF.CdsId			[CdsId],
			BNF.SitId			[SitId],
			BNF.Aliq_ISS_Rps	[Aliq_ISS_Rps],
			BNF.RPS_Envio		[RPS_Envio],
			BNF.dt_Cancel		[Cancel Date],
			BNF.cd_usuario_cancel	[User Cancel Code],
			UC.Nome_Usuario			[User Cancel Name],
			BNF.Habilita_Impostos	[Habilita_Impostos],
			BNF.Cd_Usuario		[User Code],
			US.Nome_Usuario		[User Name],
			BNF.cd_servico		[cd_servico],
			BNF.Item_lei		[Item_lei],
			BNF.CNAE			[CNAE],
			BNF.Descricao		[Description],
			BNF.dt_Protocolo	[Protocol Date],
			BNF.protocolo		[Protocol Number],
			BNF.dt_Cancel_Prefeitura	[NF Cancel Date],
			BNF.IRRF_Tx			[IRRF_Tx]
		from Base_Nota_Fiscal BNF  	with(nolock)	
		left join Site	SI 	with(nolock) on SI.Cd_Site = BNF.Ref_Acesso
		left join Pessoa P 	with(nolock) on P.cd_pes = BNF.Cd_Pes
		left join Usuario US 	with(nolock) on US.cd_usuario = BNF.cd_usuario
		left join Usuario UC 	with(nolock) on UC.cd_usuario = BNF.cd_usuario_cancel
		where 
			BNF.Nota_Fiscal = @Nota_Fiscal and BNF.Ref_Acesso = @Ref_Acesso
	End
	
	


GO
