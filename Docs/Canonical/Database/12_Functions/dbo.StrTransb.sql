SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function StrTransb(@Processo varchar(16)) returns varchar (40)
	

AS
		
	BEGIN
		Declare @Saida Varchar(40)
		Declare @Texto Varchar(40)
		Declare RsTemp Cursor  
			FOR
			   select (navio_hem + '-' + cast(Dt_Transb_hem as varchar)) TEXTO from hem_transb where num_proc_hem=@processo	
		open RsTemp 
		Fetch next from RsTemp 
			INTO @TEXTO
		Set @Saida=@TEXTO
		--FETCH NEXT FROM Rstemp
		While @@Fetch_status=0
		  BEGIN
			Set @Saida=@TEXTO+ '-' + @Saida
			FETCH NEXT FROM Rstemp	
				INTO @TEXTO
		  END
		RETURN @Saida
	END
		



GO
