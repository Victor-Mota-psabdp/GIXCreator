SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE pTipoContTar_Sel 
(
@Codigo 	Char(3) = '',
@Tipo		VarChar(30) = ''
)
 AS
	If @codigo <>  '' 
		Select 
			*
		From 	
			Tipo_Cont_Tar 	Left Outer Join Aux_Tipo_Container on Tipo_Cont_Tar.Cd_CC_Ofc = Aux_Tipo_Container.Cd_CC_Ofc
		Where
			Cd_Tp_Cont = @Codigo 
		Order by 
			Nome_Tp_Cont
	Else
		If @Tipo <> ''
			Select 
				*
			From 	
				Tipo_Cont_Tar  	Left Outer Join Aux_Tipo_Container on Tipo_Cont_Tar.Cd_CC_Ofc = Aux_Tipo_Container.Cd_CC_Ofc
			Where
				Nome_Tp_Cont = @Tipo
			Order by 	
				Nome_Tp_Cont
		Else
			Select 
				*
			From 	
				Tipo_Cont_Tar  	Left Outer Join Aux_Tipo_Container on Tipo_Cont_Tar.Cd_CC_Ofc = Aux_Tipo_Container.Cd_CC_Ofc
			Order by 	
				Nome_Tp_Cont

GO
