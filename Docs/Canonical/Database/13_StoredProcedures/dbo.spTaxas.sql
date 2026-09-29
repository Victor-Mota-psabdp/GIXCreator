SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select cast(day(@hoje()+@i) as varchar(2))+'/'+ cast(month(@Hoje()+@i) as varchar(2))+'/'+cast(year(Hoje()+@i) as varchar(4))

CREATE Procedure spTaxas

as

Declare @i as int;
Declare @Data as Varchar(10)
Declare @Hoje as Datetime
Set @Hoje='16-12-2005'
set @i=1
set @Data=cast(day(@hoje+@i) as varchar(2))+'/'+cast(month(@hoje+@i)as Varchar(2))+'/'+cast(year(@hoje+@i) as Varchar(4))

While (@i<=2) 
	Begin
		set @Data=cast(day(@hoje+@i) as varchar(2))+'/'+cast(month(@hoje+@i)as Varchar(2))+'/'+cast(year(@hoje+@i) as Varchar(4))
		Insert into paridade
			   SELECT 
				@Data, cd_tp_moeda,cd_tp_par,par_moeda 
			   FROM
				Paridade
			   WHERE
				convert(datetime,dt_par,105)=dbo.hoje(@hoje)
		Set @i=@i+1
	end	

		
	


GO
