SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_Customer_Profile_Sel] --'8'
	@ID_CP				int,
	@Tipo				char(1)
as

if @Tipo = 'A' or @Tipo = 'B'
	Begin	
		select 
			CP.ID_CP				[Code],
			Convert(varchar(10),CP.Data,103)				[Date],	
			Convert(varchar(10),CP.Dt_Vencimento,103) 		[Due Date],
			CP.Cd_Cliente			[Customer Code],
			CL.Apelido				[Customer Name],
			CP.cd_agente			[Agent Code],
			AG.Apelido				[Agent Name],
			CP.cd_subagente			[Sub-Agent Code],
			SA.Apelido				[Sub-Agent Name],
			CP.Cd_Tipo_Servico		[Type of Service Code],
			TS.Descr_Servico		[Type of Service Name],
			CP.Cd_Org				[Origin Code],			
			ISNULL(ORG.Nome_Local,CP.Cd_Org)			[Origin Name],
			CP.Cd_Vendedor			[Sales Representative Code],
			VE.Nome_Usuario			[Sales Representative Name],
			CP.Modal				[Modal Code],
			MO.Nome_TP_MODAL		[Modal  Name],
			CP.Cd_Dst				[Destination Code],
			ISNULL(DST.Nome_Local,CP.Cd_Dst)			[Destination Name],
			CP.Contato				[Contact],
			CP.ID_Registro			[Register Type Code],
			TR.Descr_Registro		[Register Type Name],
			CP.ID_Status_CP			[Status Code],
			TSC.Descr_Status		[Status Name],
			CP.Tipo_Carga			[Type of Cargo Code],
			TC.Nome_Tp_Carga		[Type of Cargo Name],
			Prazo					[Term of Payments], 	
			campo_obs				[Notes],
			CP.Mercadoria			[Merchandise], 	
			Dias					[Days],
			CP.Vlr_Venda			[Informed Sale],
			CP.Peso_TN				[TN], 
			CP.Peso_CM3_M3			[M3-CM3],
			
			CP.Cd_Usuario			[User Code],
			US.Nome_Usuario			[User Name]
		from Customer_Profile CP		with (nolock)
			join Pessoa CL				with (nolock) on CP.Cd_Cliente = CL.Cd_Pes	
			left outer	join Pessoa AG	with (nolock) on AG.Cd_Pes=CP.Cd_Agente
			left outer	join Pessoa SA	with (nolock) on SA.Cd_Pes=cp.Cd_SubAgente
			join Tipo_Servico_CP TS		with (nolock) on CP.Cd_Tipo_Servico = TS.Cd_Tipo_Servico
			left outer	join Localidade ORG		with (nolock) on CP.Cd_Org=ORG.Cd_Local
			left outer	join Localidade DST		with (nolock) on CP.Cd_Dst=DST.Cd_Local	
			left outer	join Usuario VE			with (nolock) on VE.cd_usuario=CP.Cd_Vendedor	
			left outer	join Tipo_Modal_Imp_Exp MO with (nolock) on MO.CD_TP_MODAL = CP.Modal				
			left outer	join Tipo_Registro TR	with (nolock) on TR.ID_Registro = CP.ID_Registro
			left outer	join Tipo_Status_CP TSC with (nolock) on TSC.ID_Status_CP = CP.ID_Status_CP
			left outer	join Tipo_Carga TC		with (nolock) on CP.Tipo_Carga = TC.Cd_Tp_Carga			
			left outer	join Usuario US			with (nolock) on US.cd_usuario=CP.Cd_Usuario
		where
			CP.ID_CP = @ID_CP 
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin	
		select 
			CP.ID_CP				[Code],
			Convert(varchar(10),CP.Data,103)				[Date],	
			Convert(varchar(10),CP.Dt_Vencimento,103) 		[Due Date],
			CP.Cd_Cliente			[Customer Code],
			CL.Apelido				[Customer Name],
			CP.cd_agente			[Agent Code],
			AG.Apelido				[Agent Name],
			CP.cd_subagente			[Sub-Agent Code],
			SA.Apelido				[Sub-Agent Name],
			CP.Cd_Tipo_Servico		[Type of Service Code],
			TS.Descr_Servico		[Type of Service Name],
			CP.Cd_Org				[Origin Code],
			ISNULL(ORG.Nome_Local,CP.Cd_Org)			[Origin Name],
			CP.Cd_Vendedor			[Sales Representative Code],
			VE.Nome_Usuario			[Sales Representative Name],
			CP.Modal				[Modal Code],
			MO.Nome_TP_MODAL		[Modal  Name],
			CP.Cd_Dst				[Destination Code],
			ISNULL(DST.Nome_Local,CP.Cd_Dst)			[Destination Name],
			CP.Contato				[Contact],
			CP.ID_Registro			[Register Type Code],
			TR.Descr_Registro		[Register Type Name],
			CP.ID_Status_CP			[Status Code],
			TSC.Descr_Status		[Status Name],
			CP.Tipo_Carga			[Type of Cargo Code],
			TC.Nome_Tp_Carga		[Type of Cargo Name],
			Prazo					[Term of Payments], 	
			campo_obs				[Notes],
			CP.Mercadoria			[Merchandise], 	
			Dias					[Days],
			CP.Vlr_Venda			[Informed Sale],
			CP.Peso_TN				[TN], 
			CP.Peso_CM3_M3			[M3-CM3],
			
			CP.Cd_Usuario			[User Code],
			US.Nome_Usuario			[User Name]
		from Customer_Profile CP		with (nolock)
			join Pessoa CL				with (nolock) on CP.Cd_Cliente = CL.Cd_Pes	
			left outer	join Pessoa AG	with (nolock) on AG.Cd_Pes=CP.Cd_Agente
			left outer	join Pessoa SA	with (nolock) on SA.Cd_Pes=cp.Cd_SubAgente
			join Tipo_Servico_CP TS		with (nolock) on CP.Cd_Tipo_Servico = TS.Cd_Tipo_Servico
			left outer	join Localidade ORG		with (nolock) on CP.Cd_Org=ORG.Cd_Local
			left outer	join Localidade DST		with (nolock) on CP.Cd_Dst=DST.Cd_Local	
			left outer	join Usuario VE			with (nolock) on VE.cd_usuario=CP.Cd_Vendedor	
			left outer	join Tipo_Modal_Imp_Exp MO with (nolock) on MO.CD_TP_MODAL = CP.Modal				
			left outer	join Tipo_Registro TR	with (nolock) on TR.ID_Registro = CP.ID_Registro
			left outer	join Tipo_Status_CP TSC with (nolock) on TSC.ID_Status_CP = CP.ID_Status_CP
			left outer	join Tipo_Carga TC		with (nolock) on CP.Tipo_Carga = TC.Cd_Tp_Carga
			left outer	join Usuario US			with (nolock) on US.cd_usuario=CP.Cd_Usuario
		where
			CP.ID_CP = @ID_CP 
	End

GO
