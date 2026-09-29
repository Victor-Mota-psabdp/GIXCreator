SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure spATL_IBrokerDoc_Ins(
@ID Bigint,
@GNC varchar(50),
@Documento varchar(50),
@Status varchar(1)
)
as

Declare @ID_Doc int

set @ID_DOC = (select Isnull(max(ID_DOC),0)+1 from IBROKER_DOC_V2 where ID = @ID)

insert INTO
	IBROKER_DOC_V2
	(
		ID,
		ID_Doc,
		GNC,
		Documento,
		Status
	)
	values
	(
			@ID,
			@ID_Doc,
		@GNC,
		@Documento,
		@Status
	)	
GO
