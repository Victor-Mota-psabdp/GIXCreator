SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pEventoHouse_Ins  
(
@Eventos			varchar(500)='',
@Num_Proc			varchar(16)
)
AS
	
	Declare @Total		int
	Declare @Cont		Int
	Declare @evento	varchar(20) 
	Declare @dataevento	varchar(10) 
	
	
	Set @Total = len(@eventos)
	Set @evento = ' '	

	Begin Transaction 
	Delete From evento_house where num_proc_h = @Num_Proc
	Set @cont = 1 
	while @cont<=@total 
		Begin 
			if substring(@eventos, @cont, 1)  = ',' 
				Begin 
					Set @evento = ltrim(@evento)	
					Print 'chegou'
					Set @dataevento =  right(@evento, 10) 
					Set @evento = substring(@evento, 1, len(@evento) - 10) 
					Insert Into evento_house (TpeId, Num_Proc_H, EvhData)
					Values (@evento, @Num_Proc, @dataevento)
					If @@Error <> 0 
						Begin 
							Rollback Transaction 
							Return -30
						End


					Set @evento = ' '	
				
				End 
			Else
				Begin 
					
					Set @evento = @evento + cast(substring(@eventos, @cont, 1)  as varchar(10))
					Print @evento
				End 
			Set @cont = @cont + 1 

		End

		Commit Transaction 
		Return 1

GO
