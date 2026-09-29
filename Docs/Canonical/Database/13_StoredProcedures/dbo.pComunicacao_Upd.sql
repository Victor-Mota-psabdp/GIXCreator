SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pComunicacao_Upd    Script Date: 17/10/2002 07:32:47 ******/
CREATE PROCEDURE pComunicacao_Upd
(
@Cd_Pes		varchar(10), 
@Cd_Tp_Com		varchar(3), 
@Contato		varchar(20)='', 
@Depto_Ctt		varchar(20)='', 
@Cd_Int		varchar(3)='',
@Cd_Area_Fone	varchar(4)='',
@Prefixo		varchar(4)='',
@Num_Fone		varchar(6)='', 
@Compl_Fone		varchar(40)=''
)
AS
	If  Exists(Select * From Comunicacao Where Cd_Pes = @Cd_Pes and Cd_Tp_Com=@Cd_Tp_Com)
		Update
			Comunicacao  
		Set 
			Contato = @Contato,  
			Depto_Ctt = @Depto_Ctt, 
			Cd_Int = @Cd_Int, 
			Cd_Area_Fone = @Cd_Area_Fone, 
			Prefixo = @Prefixo, 
			Num_Fone = @Num_Fone, 
			Compl_Fone = @Compl_Fone 
		Where
			Cd_Pes = @Cd_Pes and 
			Cd_Tp_Com = @Cd_Tp_Com
	Else 
		Return -1



GO
