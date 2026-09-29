SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pComunicacao_Ins    Script Date: 17/10/2002 07:32:47 ******/
CREATE PROCEDURE pComunicacao_Ins 
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
	If Not Exists(Select * From Comunicacao Where Cd_Pes = @Cd_Pes and Cd_Tp_Com=@Cd_Tp_Com)
		Insert Into Comunicacao  
			(Cd_Pes, Cd_Tp_Com,  Contato,  Depto_Ctt, Cd_Int, Cd_Area_Fone, Prefixo, Num_Fone, Compl_Fone) 
		Values 
			(@Cd_Pes, @Cd_Tp_Com,  @Contato,  @Depto_Ctt, @Cd_Int, @Cd_Area_Fone, @Prefixo, @Num_Fone, @Compl_Fone) 
	Else 
		Return -1



GO
