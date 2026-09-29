SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE        Procedure [dbo].[spPessoa_Sel]
			
		@cd_pes varchar(10),
		@Apelido varchar(25)
AS
	if @cd_pes='%' 
	   BEGIN
		Select 
			PP.Cd_Pes,
			PP.Apelido,
			PP.Nome_Raz_Soc, 
			PP.Num_CPF_CNPJ,
			TA.Nome_tp_Ativ,
			TG.Nome_tp_Grupo,
			US.Nome_Usuario,
			convert(datetime,PP.dt_cad,105) Data,
			PP.Desat_pes,
			PP.obs_pes, 
			GP.Apelido Grupo,
			Cd_Vendor Vendor,
			Cd_Planta Planta,
			PP.Num_RG_IE IE,
			PP.num_insc_munic,
			Isnull(PP.GLOBAL_ENTITY_ID,'') GLOBAL_ENTITY_ID,
			Isnull((select Top 1 cd_ax from Pessoa_ATL_AX with(nolock) where Cd_Pes = PP.Cd_Pes),'') AccountAX
		From
			Pessoa PP
			Left Outer Join Tipo_Atividade	TA with(nolock) on TA.cd_tp_ativ=PP.cd_tp_ativ
			Left Outer Join Tipo_Grupo 	TG with(nolock) on TG.cd_tp_grupo=PP.cd_tp_grupo
			Left Outer Join Usuario 	US with(nolock) on US.cd_usuario=PP.cd_usuario
			Left Outer Join Pessoa_LLP	LLP with(nolock) on PP.Cd_Pes = LLP.Cd_Pes
			Left Outer Join	Pessoa		GP with(nolock) on LLP.Cd_Pes_Grupo = GP.Cd_Pes
		Where
			PP.Apelido like @Apelido
	    END
	ELSE
	   BEGIN
		Select 
			PP.Cd_Pes,
			PP.Apelido,
			PP.Nome_Raz_Soc, 
			PP.Num_CPF_CNPJ,
			TA.Nome_tp_Ativ,
			TG.Nome_tp_Grupo,
			US.Nome_Usuario,
			convert(datetime,PP.dt_cad,105) Data,
			PP.Desat_pes,
			PP.obs_pes, 
			GP.Apelido Grupo,
			Cd_Vendor Vendor,
			Cd_Planta Planta,
			PP.Num_RG_IE IE,
			PP.num_insc_munic,
			Isnull(PP.GLOBAL_ENTITY_ID,'') GLOBAL_ENTITY_ID,
			Isnull((select Top 1 cd_ax from Pessoa_ATL_AX with(nolock) where Cd_Pes = PP.Cd_Pes),'') AccountAX
		From
			Pessoa PP
			Join Tipo_Atividade TA with(nolock) on TA.cd_tp_ativ=PP.cd_tp_ativ
			Join Tipo_Grupo TG with(nolock) on TG.cd_tp_grupo=PP.cd_tp_grupo
			Join Usuario US with(nolock) on US.cd_usuario=PP.cd_usuario
			Left Join Pessoa_LLP	LLP with(nolock) on PP.Cd_Pes = LLP.Cd_Pes
			Left Join	Pessoa		GP with(nolock) on LLP.Cd_Pes_Grupo = GP.Cd_Pes
		Where
			PP.cd_pes like @cd_pes
	   END









GO
