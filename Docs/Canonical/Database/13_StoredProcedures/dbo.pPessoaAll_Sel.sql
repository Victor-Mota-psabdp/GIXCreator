SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pPessoaAll_Sel    Script Date: 17/10/2002 07:32:51 ******/
CREATE PROCEDURE pPessoaAll_Sel 
(
@Cd_pessoa		VarChar(10)='', 
@Apelido		VarChar(20)=''
)
 AS
	If @Cd_Pessoa <> '' 
		Select 
			PS.*, TA.Nome_Tp_Ativ, TC.Nome_Tp_Classe, TG.Nome_Tp_Grupo,  US.Nome_Usuario, CC.Nome_Cta_Ctb
		From 
			Pessoa as Ps left outer Join Tipo_Atividade as TA on 
			PS.Cd_Tp_Ativ = TA.Cd_Tp_Ativ Left Outer Join Tipo_classe as TC on 
			PS.Cd_Tp_Classe = TC.Cd_Tp_Classe Left Outer Join Tipo_Grupo as TG on 
			PS.Cd_Tp_Grupo = TG.Cd_Tp_Grupo Left Outer Join Usuario as US on 
			PS.Cd_Usuario = US.Cd_Usuario Left Outer Join Cta_Ctb as CC on 
			PS.Cd_Cta_Ctb = CC.Cd_Cta_Ctb
		Where 
			Ps.Apelido = @Apelido 
	Else
		Begin 
			If @Apelido <> '' 
				Select 
					PS.*, TA.Nome_Tp_Ativ, TC.Nome_Tp_Classe, TG.Nome_Tp_Grupo,  US.Nome_Usuario, CC.Nome_Cta_Ctb
				From 
					Pessoa as Ps left outer Join Tipo_Atividade as TA on 
					PS.Cd_Tp_Ativ = TA.Cd_Tp_Ativ Left Outer Join Tipo_classe as TC on 
					PS.Cd_Tp_Classe = TC.Cd_Tp_Classe Left Outer Join Tipo_Grupo as TG on 
					PS.Cd_Tp_Grupo = TG.Cd_Tp_Grupo Left Outer Join Usuario as US on 
					PS.Cd_Usuario = US.Cd_Usuario Left Outer Join Cta_Ctb as CC on 
					PS.Cd_Cta_Ctb = CC.Cd_Cta_Ctb
				Where 
					Ps.Apelido = @Apelido 
			Else 		
				Select 
					PS.*, TA.Nome_Tp_Ativ, TC.Nome_Tp_Classe, TG.Nome_Tp_Grupo,  US.Nome_Usuario, CC.Nome_Cta_Ctb
				From 
					Pessoa as Ps left outer Join Tipo_Atividade as TA on 
					PS.Cd_Tp_Ativ = TA.Cd_Tp_Ativ Left Outer Join Tipo_classe as TC on 
					PS.Cd_Tp_Classe = TC.Cd_Tp_Classe Left Outer Join Tipo_Grupo as TG on 
					PS.Cd_Tp_Grupo = TG.Cd_Tp_Grupo Left Outer Join Usuario as US on 
					PS.Cd_Usuario = US.Cd_Usuario Left Outer Join Cta_Ctb as CC on 
					PS.Cd_Cta_Ctb = CC.Cd_Cta_Ctb
				Order by 
					Apelido 
					
		End



GO
