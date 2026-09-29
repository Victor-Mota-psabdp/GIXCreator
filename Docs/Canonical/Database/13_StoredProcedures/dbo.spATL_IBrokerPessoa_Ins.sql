SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure spATL_IBrokerPessoa_Ins(
@ID bigint,
@Cd_Pes	varchar(50),
@Ibroker	varchar(50),
@Apelido	varchar	(50),
@Detalhe	varchar(max),
@Tipo	varchar(1)
)
as

--Declare @ID bigint

--set @ID = (select Isnull(max(ID),0)+1 from IBROKER_Pessoa_V2)

	insert INTO 
			IBROKER_Pessoa_V2
			(
			ID,
			Cd_Pes,
			Ibroker,
			Apelido,
			Detalhe,
			Tipo
			)
	values
	(
			@ID,
			@Cd_Pes,
			@Ibroker,
			@Apelido,
			@Detalhe,
			@Tipo		
	)
	
GO
