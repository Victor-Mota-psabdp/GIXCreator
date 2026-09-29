SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spTemp_SAPSUN]
(
	@1 as varchar(50),
	@2 as varchar(50),
	@3 as varchar(50),
	@4 as varchar(50),
	@5 as varchar(50),
	@6 as varchar(50),
	@7 as varchar(50),
	@8 as varchar(50),
	@9 as varchar(50),
	@10 as varchar(50),
	@11 as varchar(50),
	@12 as varchar(50),
	@13 as varchar(50),
	@14 as varchar(50),
	@15 as varchar(50),
	@16 as varchar(50),
	@17 as varchar(50),
	@18 as varchar(50),
	@19 as varchar(50),
	@20 as varchar(50),
	@21 as varchar(50),
	@22 as varchar(50),
	@23 as varchar(50),
	@24 as varchar(50),
	@25 as varchar(50),
	@26 as varchar(50),
	@27 as varchar(50),
	@28 as varchar(50),
	@29 as varchar(50),
	@30 as varchar(50),
	@31 as varchar(50),
	@32 as varchar(50),
	@33 as varchar(50),
	@34 as varchar(50),
	@35 as varchar(50),
	@36 as varchar(50),
	@37 as varchar(50),
	@38 as varchar(50),
	@39 as varchar(50),
	@40 as varchar(100),
	@41 as varchar(50),
	@42 as varchar(50),
	@43 as varchar(50),
	@44 as varchar(50),
	@45 as varchar(50),
	@46 as varchar(100),
	@47 as varchar(50),
	@48 as varchar(50),
	@49 as varchar(50),
	@50 as varchar(50),
	@51 as varchar(50),
	@52 as varchar(50),
	@53 as varchar(50),
	@54 as varchar(50),
	@55 as varchar(50),
	@56 as varchar(50),
	@57 as varchar(50),
	@58 as varchar(50),
	@59 as varchar(50),
	@60 as varchar(50),
	@61 as varchar(50),
	@62 as varchar(50),
	@63 as varchar(50),
	@64 as varchar(50),
	@65 as varchar(50),
	@66 as varchar(50),
	@67 as varchar(50),
	@68 as varchar(50),
	@69 as varchar(1000),
	@70 as varchar(50),
	@71 as varchar(50),
	@72 as varchar(50),
	@73 as varchar(50),
	@74 as varchar(50),
	@75 as varchar(50),
	@76 as varchar(50),
	@77 as varchar(50),
	@78 as varchar(50),
	@79 as varchar(50),
	@80 as varchar(50),
	@81 as varchar(50),
	@82 as varchar(50),
	@83 as varchar(50)

)
as

Begin Transaction
	
		BEGIN
			insert into
					Temp_SapSUN				
			values
						(
						@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,
						@11,@12,@13,@14,@15,@16,@17,@18,@19,@20,
						@21,@22,@23,@24,@25,@26,@27,@28,@29,@30,
						@31,@32,@33,@34,@35,@36,@37,@38,@39,@40,
						@41,@42,@43,@44,@45,@46,@47,@48,@49,@50,
						@51,@52,@53,@54,@55,@56,@57,@58,@59,@60,
						@61,@62,@63,@64,@65,@66,@67,@68,@69,@70,
						@71,@72,@73,@74,@75,@76,@77,@78,@79,@80,@81,
						@82,@83
						 )
			END			

	IF @@ERROR<>0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END
COMMIT TRANSACTION


GO
